# This controller receives commits and comments from GitHub.

class GithubWebhooksController < WebhooksBaseController
  def create
    case request.headers["X-Github-Event"]
    when "ping" then pong
    when "commit_comment" then store_comment
    when "push" then store_commits
    else unhandled_event
    end
  end

  private

  # http://developer.github.com/webhooks/#ping-event
  def pong
    render text: "Pong!"
  end

  # https://developer.github.com/v3/activity/events/types/#commitcommentevent
  # https://developer.github.com/v3/repos/comments/#list-commit-comments-for-a-repository
  def store_comment
    comment = Comment.create_or_update_from_payload(params[:comment])
    push_event "comment_updated", comment: comment.as_json
    render text: "Thanks!"
  end

  def store_commits
    payloads = params[:commits]

    # Ignore commits outside the master branch.
    # It's usually experimental work in progress and not ready for review.
    if on_master_branch?(payloads)
      # The first commit of the payload is the oldest one.
      # Persist them like that (for a sensible id order), but
      # reverse them for the view, as it sorts newest first.
      commits = payloads.map { |payload|
        Commit.create_or_update_from_payload(payload, params)
      }.reverse

      push_event "commits_updated", commits: commits.as_json
    end

    render text: "Thanks!"
  end

  def on_master_branch?(payload)
    pushed_branch = params.fetch(:ref).split("/").last
    master_branch = params.fetch(:repository).fetch(:master_branch)
    pushed_branch == master_branch
  end

  def unhandled_event
    render text: "Unhandled event.", status: 412
  end
end
