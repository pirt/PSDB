require 'spec_helper'

describe ShotsHelper do
  describe "'displayShotInstance'" do
    it "should render a short view of an instance for a given shot" do
      Factory(:instancevalueset)
      helper.displayShotInstance(Instancevalueset,Instancevalueset.last.instance.name).
        should eq("no view defined")
    end
    it "should return (error) message 'unknown' if instance name was not found" do
      Factory(:instancevalueset)
      helper.displayShotInstance(Instancevalueset,"wronginstancename").should eq("unknown")
    end
    it "should render '?' if there is no valueset of given instance for this shot" do
      valSet=Factory(:instancevalueset)
      subsystem=valSet.instance.subsystem
      classtype=valSet.instance.classtype
      instance2=Factory(:instance,{:name=>"other instance",:subsystem_id=>subsystem.id, :classtype_id=>classtype.id})
      instanceName=instance2.name
      helper.displayShotInstance(Instancevalueset,instanceName).should eq("?")
    end
  end
end
