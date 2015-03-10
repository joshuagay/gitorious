# encoding: utf-8

require "force_utf8"

describe ForceUtf8::Encode do
  context "monkey patches" do
    it "includes the mutating extension" do
      str = "żółć\xCF"
      str.force_utf8!

      str.should == "żółć?"
    end

    it "includes the immutable extension" do
      str = "żółć\xCF"

      str.force_utf8.should == "żółć?"
      str.should == "żółć\xCF"
    end
  end

  context "encode!" do
    it "does not replace valid UTF-8 chars" do
      str = "żółć"

      ForceUtf8::Encode.encode!(str)

      str.should == "żółć"
      str.valid_encoding?.should be_true
    end

    it "replaces invalid UTF-8 chars with question marks" do
      str = "żółć\xCF"

      ForceUtf8::Encode.encode!(str)

      str.should == "żółć?"
      str.valid_encoding?.should be_true
    end

    it "does not attempt to mutate a nil value" do
      expect {
        ForceUtf8::Encode.encode!(nil)
      }.not_to raise_error
    end
  end

  context "encode" do
    it "does not replace valid UTF-8 chars" do
      str = "żółć"

      encoded = ForceUtf8::Encode.encode(str)

      encoded.should == "żółć"
      encoded.valid_encoding?.should be_true
    end

    it "replaces invalid UTF-8 chars with question marks" do
      str = "żółć\xCF"

      encoded = ForceUtf8::Encode.encode(str)

      encoded.should == "żółć?"
      encoded.valid_encoding?.should be_true
    end

    it "does not mutate the given string" do
      str = "żółć\xCF"

      ForceUtf8::Encode.encode(str)

      str.should == "żółć\xCF"
    end

    it "returns nil for nil value" do
      ForceUtf8::Encode.encode(nil).should be_nil
    end
  end
end
