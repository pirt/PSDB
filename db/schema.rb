# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110406103313) do

  create_table "attachments", :force => true do |t|
    t.string   "filename",                                                     :null => false
    t.string   "filetype",        :limit => 50,                                :null => false
    t.string   "description"
    t.binary   "content",                                                      :null => false
    t.integer  "attachable_id",                 :precision => 38, :scale => 0
    t.string   "attachable_type"
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
  end

  add_index "attachments", ["attachable_id", "attachable_type"], :name => "i_att_att_id_att_typ"

  create_table "classtypes", :force => true do |t|
    t.string   "name",       :limit => 256, :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "classtypes", ["name"], :name => "index_classtypes_on_name", :unique => true

  add_primary_key_trigger "classtypes"

  create_table "datatypes", :force => true do |t|
    t.string   "name",       :limit => 30, :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "datatypes", ["name"], :name => "index_datatypes_on_name", :unique => true

  add_primary_key_trigger "datatypes"

  create_table "experiments", :force => true do |t|
    t.string   "name",        :limit => 30,                                                 :null => false
    t.boolean  "active",                    :precision => 1, :scale => 0, :default => true
    t.string   "description",                                                               :null => false
    t.datetime "created_at",                                                                :null => false
    t.datetime "updated_at",                                                                :null => false
  end

  add_index "experiments", ["name"], :name => "index_experiments_on_name", :unique => true

  add_primary_key_trigger "experiments"

  create_table "instances", :force => true do |t|
    t.integer  "classtype_id", :precision => 38, :scale => 0, :null => false
    t.integer  "subsystem_id", :precision => 38, :scale => 0, :null => false
    t.string   "name",                                        :null => false
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  add_index "instances", ["classtype_id"], :name => "i_instances_classtype_id"
  add_index "instances", ["name"], :name => "index_instances_on_name", :unique => true
  add_index "instances", ["subsystem_id"], :name => "i_instances_subsystem_id"

  add_primary_key_trigger "instances"

  create_table "instancevalues", :force => true do |t|
    t.integer  "instancevalueset_id",                :precision => 38, :scale => 0, :null => false
    t.integer  "datatype_id",                        :precision => 38, :scale => 0, :null => false
    t.string   "name",                :limit => 256,                                :null => false
    t.decimal  "data_numeric"
    t.string   "data_string"
    t.binary   "data_binary"
    t.datetime "created_at",                                                        :null => false
    t.datetime "updated_at",                                                        :null => false
  end

  add_index "instancevalues", ["datatype_id"], :name => "i_instancevalues_datatype_id"
  add_index "instancevalues", ["instancevalueset_id"], :name => "valueset_index"

  add_primary_key_trigger "instancevalues"

  create_table "instancevaluesets", :force => true do |t|
    t.integer  "shot_id",     :precision => 38, :scale => 0, :null => false
    t.integer  "instance_id", :precision => 38, :scale => 0, :null => false
    t.integer  "version",     :precision => 38, :scale => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "instancevaluesets", ["instance_id"], :name => "i_ins_ins_id"
  add_index "instancevaluesets", ["shot_id"], :name => "i_instancevaluesets_shot_id"

  add_primary_key_trigger "instancevaluesets"

  create_table "shots", :force => true do |t|
    t.string   "description"
    t.integer  "experiment_id",       :precision => 38, :scale => 0, :null => false
    t.integer  "shottype_id",         :precision => 38, :scale => 0, :null => false
    t.integer  "configuration_id_id", :precision => 38, :scale => 0
    t.integer  "status",              :precision => 38, :scale => 0
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
  end

  add_index "shots", ["experiment_id"], :name => "index_shots_on_experiment_id"
  add_index "shots", ["shottype_id"], :name => "index_shots_on_shottype_id"

  add_primary_key_trigger "shots"

  create_table "shottypes", :force => true do |t|
    t.string   "name",       :limit => 30, :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "shottypes", ["name"], :name => "index_shottypes_on_name", :unique => true

  add_primary_key_trigger "shottypes"

  create_table "subsystems", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "subsystems", ["name"], :name => "index_subsystems_on_name", :unique => true

  add_primary_key_trigger "subsystems"

  add_foreign_key "instances", "classtypes", :name => "sys_c0038728"
  add_foreign_key "instances", "subsystems", :name => "sys_c0038729"

  add_foreign_key "instancevalues", "datatypes", :name => "sys_c0038745"
  add_foreign_key "instancevalues", "instancevaluesets", :name => "sys_c0038744"

  add_foreign_key "instancevaluesets", "instances", :name => "sys_c0038736"
  add_foreign_key "instancevaluesets", "shots", :name => "sys_c0038735"

  add_foreign_key "shots", "experiments", :name => "sys_c0038704"
  add_foreign_key "shots", "shottypes", :name => "sys_c0038705"

end
