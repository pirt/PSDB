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
  shot.comment           "test shot comment"
  shot.experiment {Factory(:experiment)}
  shot.shottype {Factory(:shottype)}
end
Factory.define :datatype do |datatype|
  datatype.name   "numeric"
end
Factory.define :instancedata do |instancedata|
  instancedata.shot {Factory(:shot)}
  #instancedata.instance {Factory(:instance)}
  instancedata.datatype {Factory(:datatype)}
  instancedata.name "Test parameter"
  instancedata.data_numeric 47.11
end
