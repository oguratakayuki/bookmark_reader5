require 'rails_helper'

RSpec.describe Folder, type: :model do
  describe "divide_fullpath" do
    it "return hash" do
      ret = Folder.divide_fullpath('/aaa/bbb/ccc')
      expect(ret[:title]).to eq 'ccc'
      expect(ret[:path]).to eq 'aaa/bbb'
      expect(ret[:layer]).to eq 3
    end
  end
end
