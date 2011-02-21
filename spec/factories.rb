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
Factory.define :instancedata do |instancedata|
  instancedata.shot {Factory(:shot)}
  instancedata.instance {Factory(:instance)}
  instancedata.datatype {Factory(:datatype)}
  instancedata.name "Test parameter"
  instancedata.data_numeric 47.11
end
