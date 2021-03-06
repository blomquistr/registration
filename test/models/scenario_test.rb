require 'test_helper'

class ScenarioTest < ActiveSupport::TestCase
  setup do
    @one_five   = scenarios(:scenario_one_five)
    @two_seven  = scenarios(:scenario_two_seven)
    @sort_first = -1
    @sort_last   = 1
  end

  test "scenario 1-5 is tier 1-5" do
    assert_equal '1-5', @one_five.tier
  end

  test "scenario 2-7 is season 2" do
    assert_equal 2, @two_seven.season
  end

  test "scenario 2-7 should have correct long_name" do
    assert_equal 'PFS 2-07: Death to Pathfinders', @two_seven.long_name
  end

  test "scenario 1-5 comes after 2-7 (reverse sort seasons)" do
    assert_equal @sort_last, @one_five <=> @two_seven
  end

  test "scenario 2-07 comes before 2-20 (natural sort in season)" do
    two_twenty = scenarios(:scenario_two_twenty)
    assert_equal @sort_first, @two_seven <=> two_twenty
  end

  test "Pathfinder comes before Starfinder" do
    sfs = scenarios(:starfinder_one_one)
    assert_equal @sort_first, @one_five <=> sfs
  end
  test "Diff Name comes before Starfinder 1-1" do
    diff = scenarios(:starfinder_diff_name)
    sfs = scenarios(:starfinder_one_one)
    assert_equal @sort_first, diff <=> sfs
  end

  test "Tier 1-2 comes before 3-4" do
    onetwo = scenarios(:special_one_two)
    threefour = scenarios(:special_three_four)
    assert_equal @sort_first, onetwo <=> threefour
  end

end

