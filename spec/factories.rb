Factory.define :experiment do |experiment|
  experiment.name        "P0010"
  experiment.description "Experiment description"
end
Factory.define :attachment do |attachment|
  attachment.filename    "test.png"
  attachment.filetype    "image/png"
  attachment.description "attachment description"
  attachment.content     "abcdefghijklmnopqrstuvwxyz"
end
Factory.define :shottype do |shottype|
  shottype.name "experiment shot"
end
Factory.define :shot do |shot|
  shot.description "test shot description"
  shot.association :experiment
  shot.association :shottype
end
Factory.define :classtype do |classtype|
  classtype.name "test classtype"
end
Factory.define :subsystem do |subsystem|
  subsystem.name "test subsystem"
end
Factory.define :instance do |instance|
  instance.name "test instance"
  instance.association :classtype
  instance.association :subsystem
end
Factory.define :datatype do |datatype|
  datatype.name "numeric"
end
Factory.define :instancevalue do |instancevalue|
  instancevalue.association :instancevalueset
  instancevalue.association :datatype
  instancevalue.name "Test parameter"
  instancevalue.data_numeric 47.11
end
Factory.define :instancevalueset do |instancevalueset|
  instancevalueset.association :shot
  instancevalueset.association :instance
  instancevalueset.version 0
end
Factory.define :instancevalue_image, :class=>Instancevalue do |instancevalue|
  instancevalue.association :instancevalueset
  instancevalue.association :datatype, :name=>"image"
  instancevalue.name "Test image"
  def instancevalue.getImageBlob
    imagePath=Rails.root.to_s+"/public/images/Rainbow.png"
    testImage=Magick::Image.read(imagePath)[0].to_blob  { self.format='TIF' }
    return "AAAA"+testImage
  end
  instancevalue.data_binary {instancevalue.getImageBlob}
end
Factory.define :instancevalue_2dData, :class=>Instancevalue do |instancevalue|
  instancevalue.association :instancevalueset
  instancevalue.association :datatype, :name=>"2dData"
  instancevalue.name "Test data"
  instancevalue.data_binary "AAAA1.0,2.0\n3.0,4.0\n"
  instancevalue.data_string "xlabel,ylabel,dim1,dim2"
end

