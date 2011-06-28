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
  datatype.name   "numeric"
end
Factory.define :instancevalue do |instancevalue|
  instancevalue.association :instancevalueset
  instancevalue.association :datatype
  instancevalue.name "Test parameter"
  instancevalue.data_numeric 47.11
end
Factory.define :instancevalueset do |instancevalue|
  instancevalue.association :shot
  instancevalue.association :instance
  instancevalue.version 0
end
