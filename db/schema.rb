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

ActiveRecord::Schema.define(:version => 20111220184209) do

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

  add_index "attachments", ["attachable_id"], :name => "i_attachments_attachable_id"
  add_index "attachments", ["attachable_type"], :name => "i_attachments_attachable_type"

  create_table "classtypes", :force => true do |t|
    t.string   "name",       :limit => 256, :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_primary_key_trigger "classtypes"

  create_table "datatypes", :force => true do |t|
    t.string   "name",       :limit => 30, :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_primary_key_trigger "datatypes"

  create_table "experiment_owners", :force => true do |t|
    t.integer "experiment_id", :precision => 38, :scale => 0
    t.integer "user_id",       :precision => 38, :scale => 0
  end

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
  add_index "instances", ["name"], :name => "ind_inst_on_name", :unique => true
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
  add_index "instancevalues", ["instancevalueset_id"], :name => "index_instancevaluesets"

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

  create_table "roles", :force => true do |t|
    t.string  "title"
    t.integer "user_id", :precision => 38, :scale => 0
  end

  create_table "shots", :force => true do |t|
    t.string   "description"
    t.integer  "experiment_id", :precision => 38, :scale => 0, :null => false
    t.integer  "shottype_id",   :precision => 38, :scale => 0, :null => false
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.integer  "status",        :precision => 38, :scale => 0
  end

  add_index "shots", ["experiment_id"], :name => "index_shots_on_experiment_id"
  add_index "shots", ["shottype_id"], :name => "index_shots_on_shottype_id"

  add_primary_key_trigger "shots"

  create_table "shottypes", :force => true do |t|
    t.string   "name",       :limit => 30, :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_primary_key_trigger "shottypes"

  create_table "subsystems", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "subsystems", ["name"], :name => "subsystems_u01", :unique => true

  add_primary_key_trigger "subsystems"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["persistence_token"], :name => "i_users_persistence_token"
  add_index "users", ["username"], :name => "index_users_on_username"

  add_primary_key_trigger "users"

  add_foreign_key "instances", "classtypes", :name => "sys_c0023497"
  add_foreign_key "instances", "subsystems", :name => "sys_c0023496"

  add_foreign_key "instancevalues", "datatypes", :name => "sys_c0023500"
  add_foreign_key "instancevalues", "instancevaluesets", :name => "sys_c0023501"

  add_foreign_key "instancevaluesets", "instances", :name => "sys_c0023498"
  add_foreign_key "instancevaluesets", "shots", :name => "sys_c0023499"

  add_foreign_key "shots", "experiments", :name => "sys_c0023494"
  add_foreign_key "shots", "shottypes", :name => "sys_c0023495"

end
