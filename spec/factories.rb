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
  shottype.name          "experiment shot"
end
Factory.define :shot do |shot|
  shot.description       "test shot description"
  shot.experiment {Factory(:experiment)}
  shot.shottype {Factory(:shottype)}
end
Factory.define :classtype do |classtype|
  classtype.name "test classtype"
end
Factory.define :subsystem do |subsystem|
  subsystem.name "test subsystem"
end
Factory.define :instance do |instance|
  instance.name "test instance"
  instance.classtype {Factory(:classtype)}
  instance.subsystem {Factory(:subsystem)}
end
Factory.define :datatype do |datatype|
  datatype.name   "numeric"
end
Factory.define :instancevalue do |instancevalue|
  instancevalue.instancevalueset {Factory(:instancevalueset)}
  instancevalue.datatype {Factory(:datatype)}
  instancevalue.name "Test parameter"
  instancevalue.data_numeric 47.11
end
Factory.define :instancevalueset do |instancevalue|
  instancevalue.shot {Factory(:shot)}
  instancevalue.instance {Factory(:instance)}
  instancevalue.version 0
end
