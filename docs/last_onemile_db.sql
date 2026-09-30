-- Project Name : Mr's4G
-- Date/Time    : 2026/09/07 16:19:46
-- Author       : H30715
-- RDBMS Type   : PostgreSQL
-- Application  : A5:SQL Mk-2

/*
  << 注意！！ >>
  BackupToTempTable, RestoreFromTempTable疑似命令が付加されています。
  これにより、drop table, create table 後もデータが残ります。
  この機能は一時的に $$TableName のような一時テーブルを作成します。
  この機能は A5:SQL Mk-2でのみ有効であることに注意してください。
*/

-- 管理者
-- * BackupToTempTable
DROP TABLE if exists "admin" CASCADE;

-- * RestoreFromTempTable
CREATE TABLE "admin" (
  "admin_id" serial NOT NULL
  , "name" character varying(20) NOT NULL
  , "password" character varying(255) NOT NULL
  , CONSTRAINT "admin_PKC" PRIMARY KEY ("admin_id")
) ;

-- 注文詳細
-- * BackupToTempTable
DROP TABLE if exists "order_details" CASCADE;

-- * RestoreFromTempTable
CREATE TABLE "order_details" (
  "order_detail_id" serial NOT NULL
  , "item_id" integer NOT NULL
  , "order_id" integer NOT NULL
  , "quantity" integer DEFAULT 1 NOT NULL
  , CONSTRAINT "order_details_PKC" PRIMARY KEY ("order_detail_id")
) ;

-- 注文
-- * BackupToTempTable
DROP TABLE if exists "orders" CASCADE;

-- * RestoreFromTempTable
CREATE TABLE "orders" (
  "order_id" serial NOT NULL
  , "order_no" character varying(7) NOT NULL
  , "name" character varying(20) NOT NULL
  , "address" character varying(255) NOT NULL
  , "phone" character varying(11) NOT NULL
  , "note" TEXT
  , "ordered_at" timestamp with time zone DEFAULT NOW()
  , "delivery_staff" character varying(20)
  , "delivery_status" character varying(10) DEFAULT '未対応' NOT NULL
  , "notdelivery_note" text
  , CONSTRAINT "orders_PKC" PRIMARY KEY ("order_id")
) ;

ALTER TABLE "orders" ADD CONSTRAINT "注文番号"
  UNIQUE ("order_no") ;

-- 物資
-- * BackupToTempTable
DROP TABLE if exists "items" CASCADE;

-- * RestoreFromTempTable
CREATE TABLE "items" (
  "item_id" serial NOT NULL
  , "item_name" character varying(100) NOT NULL
  , "stock" integer DEFAULT 0 NOT NULL
  , "location" character varying(10) NOT NULL
  , "genre_id" integer NOT NULL
  , "updated_at" timestamp with time zone DEFAULT NOW() NOT NULL
  , CONSTRAINT "items_PKC" PRIMARY KEY ("item_id")
) ;

ALTER TABLE "order_details"
  ADD CONSTRAINT "order_details_FK1" FOREIGN KEY ("item_id") REFERENCES "items"("item_id");

ALTER TABLE "order_details"
  ADD CONSTRAINT "order_details_FK2" FOREIGN KEY ("order_id") REFERENCES "orders"("order_id")
  ON DELETE CASCADE;

COMMENT ON TABLE "admin" IS '管理者';
COMMENT ON COLUMN "admin"."admin_id" IS '管理ID:自動生成';
COMMENT ON COLUMN "admin"."name" IS '名前';
COMMENT ON COLUMN "admin"."password" IS 'パスワード';

COMMENT ON TABLE "order_details" IS '注文詳細';
COMMENT ON COLUMN "order_details"."order_detail_id" IS '注文詳細ID:自動生成される';
COMMENT ON COLUMN "order_details"."item_id" IS '品目ID　';
COMMENT ON COLUMN "order_details"."order_id" IS '注文ID';
COMMENT ON COLUMN "order_details"."quantity" IS '数量';

COMMENT ON TABLE "orders" IS '注文';
COMMENT ON COLUMN "orders"."order_id" IS '注文ID:自動生成';
COMMENT ON COLUMN "orders"."order_no" IS '注文番号:Java側でランダム自動生成';
COMMENT ON COLUMN "orders"."name" IS '名前';
COMMENT ON COLUMN "orders"."address" IS '住所';
COMMENT ON COLUMN "orders"."phone" IS '電話番号';
COMMENT ON COLUMN "orders"."note" IS '備考';
COMMENT ON COLUMN "orders"."ordered_at" IS '注文日時';
COMMENT ON COLUMN "orders"."delivery_staff" IS '配送担当者';
COMMENT ON COLUMN "orders"."delivery_status" IS '配送ステータス:登録時''未対応''で登録される';
COMMENT ON COLUMN "orders"."notdelivery_note" IS '配送不可理由';

COMMENT ON TABLE "items" IS '物資';
COMMENT ON COLUMN "items"."item_id" IS '品目ID　';
COMMENT ON COLUMN "items"."item_name" IS '品目名';
COMMENT ON COLUMN "items"."stock" IS '在庫数';
COMMENT ON COLUMN "items"."location" IS '場所';
COMMENT ON COLUMN "items"."genre_id" IS 'ジャンルID:01:食料・飲料 02:衛生・衣料品 03:生活・日用品 04:防寒・睡眠・衣類 05:インフラ・環境整備';
COMMENT ON COLUMN "items"."updated_at" IS '更新日時';

