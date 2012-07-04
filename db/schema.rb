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

ActiveRecord::Schema.define(:version => 20120704160409) do

  create_table "goals", :force => true do |t|
    t.string   "goal"
    t.string   "category"
    t.datetime "due"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "values"
    t.string   "accountability"
    t.integer  "is_complete",    :default => 0
    t.integer  "user_id"
    t.date     "completed_at"
    t.integer  "is_private",     :default => 0
  end

  create_table "mentor_users", :force => true do |t|
    t.integer  "mentor_user_id"
    t.integer  "student_user_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "reflection_questions", :force => true do |t|
    t.string   "qno"
    t.text     "question"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tasks", :force => true do |t|
    t.string   "task"
    t.integer  "goal_id"
    t.datetime "due"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "is_complete",  :default => 0
    t.datetime "startdue"
    t.date     "completed_at"
  end

  create_table "tasksprogresses", :force => true do |t|
    t.datetime "date"
    t.integer  "task_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_comment_last_seen", :force => true do |t|
    t.integer  "task_id"
    t.integer  "goal_id"
    t.integer  "user_id"
    t.datetime "last_seen"
  end

  create_table "user_comments", :force => true do |t|
    t.integer  "task_id"
    t.integer  "goal_id"
    t.integer  "goal_user_id"
    t.integer  "comment_user_id"
    t.text     "comment"
    t.integer  "is_read",         :default => 0
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "user_last_seen_comments", :force => true do |t|
    t.integer  "goal_id"
    t.integer  "task_id"
    t.integer  "user_id"
    t.datetime "last_seen"
  end

  create_table "user_reflections", :force => true do |t|
    t.integer  "user_id"
    t.string   "question"
    t.text     "answer"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "is_complete"
    t.integer  "access_level",                          :default => 0
    t.integer  "ileteam",                               :default => 1
    t.integer  "section_number",                        :default => 1
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
