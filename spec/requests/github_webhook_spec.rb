require "rails_helper"

describe "Receiving GitHub payloads by webhook" do
  it "handles pings zenfully" do
    post "/github_webhook",
      { payload: { zen: "Yo.", hook_id: 123 }.to_json },
      { "X-Github-Event" => "ping" }

    expect(response).to be_success
  end

  it "stores commit comments" do
    post "/github_webhook",
      { payload: { comment: { some: "Data." } }.to_json },
      { "X-Github-Event" => "commit_comment" }

    expect(response).to be_success

    comment = Comment.last!
    p comment
    expect(comment.payload[:some]).to eq "Data."
  end
end