# encoding: utf-8
# --
# The MIT License (MIT)
#
# Copyright (C) 2013 Gitorious AS
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#++
require "test_helper"
require "just_paginate"

describe JustPaginate do
  describe "The backend pagination function" do
    it "basically works like this" do
      paged_collection = [1,2,3,4,5,6,7,8,9,10]

      entries, page_count = JustPaginate.paginate(1, 5, 100) do |index_range|
        paged_collection.slice(index_range)
      end

      assert_equal 5, entries.size
      assert_equal 20, page_count
      assert_equal [1,2,3,4,5], entries
    end

    it "blows up if no selection strategy block is present" do
      assert_raises RuntimeError do
        JustPaginate.paginate(1, 20, 100)
      end
    end

    it "provides predicate to check if pagination would exceed total pagecount" do
      assert JustPaginate.page_out_of_bounds?(7,2,4)
      assert !JustPaginate.page_out_of_bounds?(1,20,100)
    end

    it "states that pages below page 1 are out of bounds" do
      assert JustPaginate.page_out_of_bounds?(-2,2,4)
      assert JustPaginate.page_out_of_bounds?(-1,2,4)
      assert JustPaginate.page_out_of_bounds?(0,2,4)
    end

    it "calculates correct total page count" do
      assert_equal 25, JustPaginate.total_page_number(500, 20)
      assert_equal 25, JustPaginate.total_page_number(498, 20)
    end

    it "correctly applies the supplied selection strategy" do
      ran = false
      sliced_entries, page_count = JustPaginate.paginate(1, 5, 10) do |index_range|
        assert index_range.class == Range
        assert_equal 0..4, index_range
        ran = true
      end
      assert ran, "selection block didn't run"
    end

    it "calculates correct index ranges" do
      assert_equal 0..1, JustPaginate.index_range(1,2,4)
      assert_equal 2..3, JustPaginate.index_range(2,2,4)

      assert_equal 0..2, JustPaginate.index_range(1,3,9)
      assert_equal 3..5, JustPaginate.index_range(2,3,9)
      assert_equal 6..8, JustPaginate.index_range(3,3,9)

      assert_equal 0..2, JustPaginate.index_range(1,3,9)
      assert_equal 3..5, JustPaginate.index_range(2,3,9)
      assert_equal 6..8, JustPaginate.index_range(3,3,9)

      assert_equal 0..19, JustPaginate.index_range(1,20,100)
      assert_equal 60..79, JustPaginate.index_range(4,20,100)
      assert_equal 60..79, JustPaginate.index_range(4,20,95)
      assert_equal 80..99, JustPaginate.index_range(5,20,100)
      assert_equal 80..95, JustPaginate.index_range(5,20,95)

      assert_equal 460..479, JustPaginate.index_range(24,20,500)
      assert_equal 480..499, JustPaginate.index_range(25,20,500)
    end
  end

  it "raises exception when out of bounds" do
    assert_equal 2..3, JustPaginate.index_range(2,2,4)
    assert_raises(RangeError) { JustPaginate.index_range(3,2,4) }
    assert_raises(RangeError) { JustPaginate.index_range(4,2,4) }
    assert_raises(RangeError) { JustPaginate.index_range(0,2,4) }
    assert_raises(RangeError) { JustPaginate.index_range(10,30,0) }
  end

  it "returns 0-0 range for first page in empty collection" do
     assert_equal 0..0, JustPaginate.index_range(1,2,0)
  end

  describe "The frontend pagination html helper" do
    it "basically works like this" do
      generated = JustPaginate.page_navigation(1, 10) { |page_no| "/projects/index?page=#{page_no}" }
      # TODO write this and following tests after I've manually browser-reload-iterated something stable'
    end

    it "does page nav labels, truncation and quicklinks correctly" do
      assert_correct_paging_labels "", 0, 0
      assert_correct_paging_labels "", 1, 0
      assert_correct_paging_labels "", 2, 0

      assert_correct_paging_labels "1", 1, 1
      assert_correct_paging_labels "1 2", 1, 2

      assert_correct_paging_labels "1 2 3 4 5 6 7 8 9 10", 1, 10

      assert_correct_paging_labels "1 2 3 4 5 6 7 8 9 10 ... 50 >", 1, 50
      assert_correct_paging_labels "1 2 3 4 5 6 7 8 9 10 ... 50 >", 5, 50
      assert_correct_paging_labels "1 2 3 4 5 6 7 8 9 10 ... 50 >", 10, 50
      assert_correct_paging_labels "1 2 3 4 5 6 7 8 9 10 ... 545 >", 1, 545

      assert_correct_paging_labels "< 1 ... 11 12 13 14 15 16 17 18 19 20 ... 50 >", 11, 50
      assert_correct_paging_labels "< 1 ... 12 13 14 15 16 17 18 19 20 21 ... 50 >", 12, 50
      assert_correct_paging_labels "< 1 ... 21 22 23 24 25 26 27 28 29 30 ... 50 >", 21, 50
      assert_correct_paging_labels "< 1 ... 40 41 42 43 44 45 46 47 48 49 ... 50 >", 40, 50

      assert_correct_paging_labels "< 1 ... 41 42 43 44 45 46 47 48 49 50", 41, 50
      assert_correct_paging_labels "< 1 ... 41 42 43 44 45 46 47 48 49 50", 45, 50
      assert_correct_paging_labels "< 1 ... 41 42 43 44 45 46 47 48 49 50", 50, 50

      assert_correct_paging_labels "< 1 ... 16 17 18 19 20 21 22 23 24 25", 24, 25
      assert_correct_paging_labels "< 1 ... 16 17 18 19 20 21 22 23 24 25", 25, 25
    end
  end

  def assert_correct_paging_labels(expected_joined, page, total)
    p = JustPaginate
    actual = p.page_labels(page, total).join(" ")
    assert_equal expected_joined, actual, "labels didn't match expected paging labels'"
  end

end
