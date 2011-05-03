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

  create_table "experiments", :force => true do |t|
    t.string   "name",        :limit => 30,                                                 :null => false
    t.boolean  "active",                    :precision => 1, :scale => 0, :default => true
    t.string   "description",                                                               :null => false
    t.datetime "created_at",                                                                :null => false
    t.datetime "updated_at",                                                                :null => false
  end

  add_index "experiments", ["name"], :name => "index_experiments_on_name", :unique => true

  add_primary_key_trigger "experiments"

  create_table "instancedatas", :force => true do |t|
    t.integer  "instancedataset_id",                :precision => 38, :scale => 0, :null => false
    t.integer  "datatype_id",                       :precision => 38, :scale => 0, :null => false
    t.string   "name",               :limit => 256,                                :null => false
    t.decimal  "data_numeric"
    t.string   "data_string"
    t.binary   "data_binary"
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
  end

  add_primary_key_trigger "instancedatas"

  create_table "instancedatasets", :force => true do |t|
    t.integer  "shot_id",     :precision => 38, :scale => 0, :null => false
    t.integer  "instance_id", :precision => 38, :scale => 0, :null => false
    t.integer  "version",     :precision => 38, :scale => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_primary_key_trigger "instancedatasets"

  create_table "instances", :force => true do |t|
    t.integer  "classtype_id", :precision => 38, :scale => 0, :null => false
    t.integer  "subsystem_id", :precision => 38, :scale => 0, :null => false
    t.string   "name",                                        :null => false
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  add_primary_key_trigger "instances"

  create_table "shots", :force => true do |t|
    t.string   "description"
    t.integer  "experiment_id", :precision => 38, :scale => 0, :null => false
    t.integer  "shottype_id",   :precision => 38, :scale => 0, :null => false
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
  end

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

  add_primary_key_trigger "subsystems"

  add_foreign_key "instancedatas", "datatypes", :name => "sys_c00393866"
  add_foreign_key "instancedatas", "instancedatasets", :name => "sys_c00393865"

  add_foreign_key "instancedatasets", "instances", :name => "sys_c00393857"
  add_foreign_key "instancedatasets", "shots", :name => "sys_c00393856"

  add_foreign_key "instances", "classtypes", :name => "sys_c00393849"
  add_foreign_key "instances", "subsystems", :name => "sys_c00393850"

  add_foreign_key "shots", "experiments", :name => "sys_c00393825"
  add_foreign_key "shots", "shottypes", :name => "sys_c00393826"

end
