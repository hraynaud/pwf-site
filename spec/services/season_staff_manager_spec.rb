describe SeasonStaffManager do
  describe "initialize" do
    it "works" do
      expect(SeasonStaffManager.new(Season.current)).to_not be_nil
    end
  end
end
