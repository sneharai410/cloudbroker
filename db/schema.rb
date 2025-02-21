# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_02_20_110718) do
  create_table "cloudlets", force: :cascade do |t|
    t.integer "length"
    t.integer "file_size"
    t.integer "output_size"
    t.string "workload_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "datacenters", force: :cascade do |t|
    t.string "name", null: false
    t.integer "num_hosts", default: 1
    t.integer "pe_mips", default: 1000
    t.integer "ram", default: 8192
    t.integer "storage", default: 1000000
    t.integer "bandwidth", default: 10000
    t.string "scheduling_policy", default: "TimeShared"
    t.string "power_model", default: "PowerAware"
    t.integer "latency", default: 10
    t.string "topology", default: "Mesh"
    t.string "bandwidth_policy", default: "Best Effort"
    t.string "storage_type", default: "SSD"
    t.float "cpu_cost", default: 0.05
    t.float "ram_cost", default: 0.01
    t.float "storage_cost", default: 0.001
    t.float "bw_cost", default: 0.005
    t.float "power_usage", default: 200.0
    t.float "idle_power", default: 50.0
    t.boolean "autoscaling", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hosts", force: :cascade do |t|
    t.integer "datacenter_id", null: false
    t.integer "ram"
    t.integer "storage"
    t.integer "bandwidth"
    t.integer "pe_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["datacenter_id"], name: "index_hosts_on_datacenter_id"
  end

  create_table "instance_types", force: :cascade do |t|
    t.string "name"
    t.integer "cpus"
    t.integer "memoryInMB"
    t.decimal "pricePerHour"
    t.string "region"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "simulation_results", force: :cascade do |t|
    t.integer "datacenter_id"
    t.string "datacenter_name"
    t.float "datacenter_cpu_cost"
    t.float "datacenter_ram_cost"
    t.float "datacenter_storage_cost"
    t.float "datacenter_bw_cost"
    t.integer "host_id"
    t.integer "host_cpu_cores"
    t.integer "host_ram"
    t.integer "host_storage"
    t.integer "host_bw"
    t.float "host_mips"
    t.integer "vm_id"
    t.integer "vm_cpu_cores"
    t.integer "vm_ram"
    t.integer "vm_storage"
    t.integer "vm_bw"
    t.float "vm_mips"
    t.integer "cloudlet_id"
    t.integer "cloudlet_length"
    t.integer "cloudlet_pes"
    t.integer "cloudlet_file_size"
    t.integer "cloudlet_output_size"
    t.float "execution_time"
    t.float "cpu_utilization"
    t.float "ram_utilization"
    t.float "bw_utilization"
    t.float "storage_utilization"
    t.boolean "execution_time_breach"
    t.boolean "cpu_breach"
    t.boolean "ram_breach"
    t.boolean "bw_breach"
    t.float "cost"
    t.float "sla_breach_cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "vms", force: :cascade do |t|
    t.integer "datacenter_id", null: false
    t.integer "mips"
    t.integer "ram"
    t.integer "storage"
    t.integer "bandwidth"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["datacenter_id"], name: "index_vms_on_datacenter_id"
  end

  add_foreign_key "hosts", "datacenters"
  add_foreign_key "vms", "datacenters"
end
