require 'rails_helper'

RSpec.describe Folder, type: :model do
  describe "body_sync" do
    context "作成時" do
      it "bodyにhrefのurlのbodyが保存されること" do
        bookmark = build(:bookmark)
        allow(bookmark).to receive(:sync_body)
        expect(bookmark.valid?).not_to eq true
      end
    end
  end
end
