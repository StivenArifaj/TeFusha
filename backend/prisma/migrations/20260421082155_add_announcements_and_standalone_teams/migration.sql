-- CreateEnum
CREATE TYPE "AnnouncementType" AS ENUM ('kerko_lojtar', 'kerko_kundershtare', 'kerko_ekip');

-- CreateTable
CREATE TABLE "announcements" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "titull" VARCHAR(150) NOT NULL,
    "pershkrim" TEXT NOT NULL,
    "lloji_sportit" VARCHAR(50) NOT NULL,
    "vendndodhja" VARCHAR(200),
    "data_lojes" TIMESTAMP(3),
    "lojtare_nevojitet" INTEGER NOT NULL DEFAULT 1,
    "tipi" "AnnouncementType" NOT NULL,
    "statusi" TEXT NOT NULL DEFAULT 'aktiv',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "announcements_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "announcement_responses" (
    "id" SERIAL NOT NULL,
    "announcementId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "mesazhi" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "announcement_responses_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "standalone_teams" (
    "id" SERIAL NOT NULL,
    "emri" VARCHAR(100) NOT NULL,
    "lloji_sportit" VARCHAR(50) NOT NULL,
    "kapiteni_id" INTEGER NOT NULL,
    "pershkrim" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "standalone_teams_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "standalone_team_members" (
    "id" SERIAL NOT NULL,
    "ekipi_id" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "roli" TEXT NOT NULL DEFAULT 'anetare',
    "joined_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "standalone_team_members_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "standalone_team_members_ekipi_id_userId_key" ON "standalone_team_members"("ekipi_id", "userId");

-- AddForeignKey
ALTER TABLE "announcements" ADD CONSTRAINT "announcements_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "announcement_responses" ADD CONSTRAINT "announcement_responses_announcementId_fkey" FOREIGN KEY ("announcementId") REFERENCES "announcements"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "announcement_responses" ADD CONSTRAINT "announcement_responses_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "standalone_teams" ADD CONSTRAINT "standalone_teams_kapiteni_id_fkey" FOREIGN KEY ("kapiteni_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "standalone_team_members" ADD CONSTRAINT "standalone_team_members_ekipi_id_fkey" FOREIGN KEY ("ekipi_id") REFERENCES "standalone_teams"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "standalone_team_members" ADD CONSTRAINT "standalone_team_members_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
