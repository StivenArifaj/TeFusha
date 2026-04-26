import { prisma } from '../utils/prisma';

export async function getAvailableSlots(fieldId: number, date: Date): Promise<{ time: string, isAvailable: boolean }[]> {
  const allSlots = generateHourlySlots('08:00', '22:00');

  const existing = await prisma.booking.findMany({
    where: {
      fusha_id: fieldId,
      data_rezervimit: date,
      statusi: { in: ['ne_pritje', 'konfirmuar'] },
    },
    select: { ora_fillimit: true, ora_mbarimit: true },
  });

  return allSlots.map(slot => {
    const slotStart = toMinutes(slot);
    const slotEnd   = slotStart + 60;
    const isTaken = existing.some((b: any) => {
      const bStart = new Date(b.ora_fillimit).getUTCHours() * 60 + new Date(b.ora_fillimit).getUTCMinutes();
      const bEnd   = new Date(b.ora_mbarimit).getUTCHours() * 60 + new Date(b.ora_mbarimit).getUTCMinutes();
      return slotStart < bEnd && slotEnd > bStart;
    });
    return { time: slot, isAvailable: !isTaken };
  });
}

export async function createBookingAtomically(data: {
  fusha_id: number;
  perdoruesi_id: number;
  data_rezervimit: Date;
  ora_fillimit: string;
  ora_mbarimit: string;
  cmimi_total: number;
}) {
  return prisma.$transaction(async (tx: any) => {
    // Row-level lock to prevent race conditions
    const conflict = await tx.$queryRaw<{ id: number }[]>`
      SELECT id FROM bookings
      WHERE fusha_id = ${data.fusha_id}
        AND data_rezervimit = ${data.data_rezervimit}
        AND statusi != 'anuluar'::"BookingStatus"
        AND ora_fillimit < ${data.ora_mbarimit}::time
        AND ora_mbarimit > ${data.ora_fillimit}::time
      FOR UPDATE
    `;
    if (conflict.length > 0) {
      throw new Error('Ora është e zënë — zgjedh një orar tjetër');
    }
    return tx.booking.create({
      data: {
        fusha_id:        data.fusha_id,
        perdoruesi_id:   data.perdoruesi_id,
        data_rezervimit: data.data_rezervimit,
        ora_fillimit:    new Date(`1970-01-01T${data.ora_fillimit}:00Z`),
        ora_mbarimit:    new Date(`1970-01-01T${data.ora_mbarimit}:00Z`),
        cmimi_total:     data.cmimi_total,
      },
    });
  });
}

function generateHourlySlots(start: string, end: string): string[] {
  const slots: string[] = [];
  let h = parseInt(start.split(':')[0]);
  const endH = parseInt(end.split(':')[0]);
  while (h < endH) {
    slots.push(`${String(h).padStart(2, '0')}:00`);
    h++;
  }
  return slots;
}

function toMinutes(time: string): number {
  const [h, m] = time.split(':').map(Number);
  return h * 60 + m;
}