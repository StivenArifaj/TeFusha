import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  const hash = await bcrypt.hash('password123', 10);
  
  // 1. Regular User
  await prisma.user.upsert({
    where: { email: 'user@test.com' },
    update: {},
    create: {
      emri: 'Test User',
      email: 'user@test.com',
      fjalekalimi: hash,
      nr_telefoni: '0691234567',
      roli: 'perdorues',
    },
  });

  // 2. Field Owner (Pronar Fushe)
  await prisma.user.upsert({
    where: { email: 'owner@test.com' },
    update: {},
    create: {
      emri: 'Test Owner',
      email: 'owner@test.com',
      fjalekalimi: hash,
      nr_telefoni: '0691234568',
      roli: 'pronar_fushe',
    },
  });

  // 3. Admin
  await prisma.user.upsert({
    where: { email: 'admin@test.com' },
    update: {},
    create: {
      emri: 'Test Admin',
      email: 'admin@test.com',
      fjalekalimi: hash,
      nr_telefoni: '0691234569',
      roli: 'admin',
    },
  });

  console.log('Fake users created successfully!');
  console.log('1. User -> Email: user@test.com / Password: password123');
  console.log('2. Owner -> Email: owner@test.com / Password: password123');
  console.log('3. Admin -> Email: admin@test.com / Password: password123');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
