require 'rails_helper'

RSpec.describe Folder, type: :model do
  describe "callbacks" do
    context "on create" do
      it "body_syncが呼ばれること" do
        bookmark = build(:bookmark)
        #expect(bookmark).to receive(:sync_body).with(bookmark.id, bookmark.href)
        expect(bookmark).to receive(:sync_body).with do |args|
          debugger
        end
        bookmark.save
      end
    end
  end
  #describe "body_sync" do
  #  it "" do
  #    CrawlerWorker.perform_async id, url
  #  end
  #end
end
