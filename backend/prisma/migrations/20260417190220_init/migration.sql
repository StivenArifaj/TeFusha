-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('perdorues', 'pronar_fushe', 'admin');

-- CreateEnum
CREATE TYPE "FieldType" AS ENUM ('futboll', 'basketboll', 'tenis', 'volejboll', 'tjeter');

-- CreateEnum
CREATE TYPE "FieldStatus" AS ENUM ('aktiv', 'joaktiv', 'ne_mirembajtje');

-- CreateEnum
CREATE TYPE "BookingStatus" AS ENUM ('ne_pritje', 'konfirmuar', 'anuluar');

-- CreateEnum
CREATE TYPE "EventType" AS ENUM ('eventi', 'kampionat', 'turneu');

-- CreateEnum
CREATE TYPE "EventStatus" AS ENUM ('planifikuar', 'aktiv', 'perfunduar');

-- CreateTable
CREATE TABLE "users" (
    "id" SERIAL NOT NULL,
    "emri" VARCHAR(100) NOT NULL,
    "email" VARCHAR(150) NOT NULL,
    "fjalekalimi" VARCHAR(255) NOT NULL,
    "nr_telefoni" VARCHAR(20),
    "roli" "UserRole" NOT NULL DEFAULT 'perdorues',
    "data_regjistrimit" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "fields" (
    "id" SERIAL NOT NULL,
    "emri_fushes" VARCHAR(100) NOT NULL,
    "lloji_fushes" "FieldType" NOT NULL,
    "vendndodhja" VARCHAR(200) NOT NULL,
    "qyteti" VARCHAR(100) NOT NULL,
    "cmimi_orari" DECIMAL(10,2) NOT NULL,
    "kapaciteti" INTEGER NOT NULL,
    "pajisjet" TEXT,
    "statusi" "FieldStatus" NOT NULL DEFAULT 'aktiv',
    "lat" DOUBLE PRECISION,
    "lng" DOUBLE PRECISION,
    "pronari_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "fields_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "bookings" (
    "id" SERIAL NOT NULL,
    "fusha_id" INTEGER NOT NULL,
    "perdoruesi_id" INTEGER NOT NULL,
    "data_rezervimit" DATE NOT NULL,
    "ora_fillimit" TIME(6) NOT NULL,
    "ora_mbarimit" TIME(6) NOT NULL,
    "statusi" "BookingStatus" NOT NULL DEFAULT 'ne_pritje',
    "cmimi_total" DECIMAL(10,2) NOT NULL,
    "data_krijimit" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "bookings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "events" (
    "id" SERIAL NOT NULL,
    "emri_eventit" VARCHAR(150) NOT NULL,
    "lloji" "EventType" NOT NULL,
    "fusha_id" INTEGER NOT NULL,
    "data_fillimit" DATE NOT NULL,
    "data_mbarimit" DATE NOT NULL,
    "nr_max_ekipesh" INTEGER NOT NULL,
    "organizatori_id" INTEGER NOT NULL,
    "statusi" "EventStatus" NOT NULL DEFAULT 'planifikuar',

    CONSTRAINT "events_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "teams" (
    "id" SERIAL NOT NULL,
    "emri" VARCHAR(100) NOT NULL,
    "logo_url" TEXT,
    "kapiteni_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "teams_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "event_teams" (
    "eventi_id" INTEGER NOT NULL,
    "ekipi_id" INTEGER NOT NULL,

    CONSTRAINT "event_teams_pkey" PRIMARY KEY ("eventi_id","ekipi_id")
);

-- CreateTable
CREATE TABLE "team_members" (
    "id" SERIAL NOT NULL,
    "ekipi_id" INTEGER NOT NULL,
    "perdoruesi_id" INTEGER NOT NULL,

    CONSTRAINT "team_members_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "matches" (
    "id" SERIAL NOT NULL,
    "eventi_id" INTEGER NOT NULL,
    "ekipi_shtepi_id" INTEGER NOT NULL,
    "ekipi_udhetimit_id" INTEGER NOT NULL,
    "gola_shtepi" INTEGER,
    "gola_udhetimit" INTEGER,
    "data_ndeshjes" TIMESTAMP(3),
    "raundi" VARCHAR(50),

    CONSTRAINT "matches_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "matchmaking_posts" (
    "id" SERIAL NOT NULL,
    "perdoruesi_id" INTEGER NOT NULL,
    "titulli" VARCHAR(150) NOT NULL,
    "pershkrimi" TEXT NOT NULL,
    "lloji_sportit" VARCHAR(50) NOT NULL,
    "qyteti" VARCHAR(100) NOT NULL,
    "data_ndeshjes" DATE,
    "statusi" TEXT NOT NULL DEFAULT 'aktiv',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "matchmaking_posts_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- AddForeignKey
ALTER TABLE "fields" ADD CONSTRAINT "fields_pronari_id_fkey" FOREIGN KEY ("pronari_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "bookings" ADD CONSTRAINT "bookings_fusha_id_fkey" FOREIGN KEY ("fusha_id") REFERENCES "fields"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "bookings" ADD CONSTRAINT "bookings_perdoruesi_id_fkey" FOREIGN KEY ("perdoruesi_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "events" ADD CONSTRAINT "events_fusha_id_fkey" FOREIGN KEY ("fusha_id") REFERENCES "fields"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "events" ADD CONSTRAINT "events_organizatori_id_fkey" FOREIGN KEY ("organizatori_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "teams" ADD CONSTRAINT "teams_kapiteni_id_fkey" FOREIGN KEY ("kapiteni_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "event_teams" ADD CONSTRAINT "event_teams_eventi_id_fkey" FOREIGN KEY ("eventi_id") REFERENCES "events"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "event_teams" ADD CONSTRAINT "event_teams_ekipi_id_fkey" FOREIGN KEY ("ekipi_id") REFERENCES "teams"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "team_members" ADD CONSTRAINT "team_members_ekipi_id_fkey" FOREIGN KEY ("ekipi_id") REFERENCES "teams"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "team_members" ADD CONSTRAINT "team_members_perdoruesi_id_fkey" FOREIGN KEY ("perdoruesi_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "matches" ADD CONSTRAINT "matches_eventi_id_fkey" FOREIGN KEY ("eventi_id") REFERENCES "events"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "matches" ADD CONSTRAINT "matches_ekipi_shtepi_id_fkey" FOREIGN KEY ("ekipi_shtepi_id") REFERENCES "teams"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "matches" ADD CONSTRAINT "matches_ekipi_udhetimit_id_fkey" FOREIGN KEY ("ekipi_udhetimit_id") REFERENCES "teams"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "matchmaking_posts" ADD CONSTRAINT "matchmaking_posts_perdoruesi_id_fkey" FOREIGN KEY ("perdoruesi_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
