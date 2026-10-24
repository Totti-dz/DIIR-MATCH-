-- اختياري: منع حجز نفس الموعد مرتين على مستوى قاعدة البيانات.
-- 1) أولاً تأكد أنه لا توجد تكرارات حالية (يجب أن تعود النتيجة فارغة):
SELECT field_id, booking_date, booking_time, count(*)
FROM bookings WHERE status <> 'rejected'
GROUP BY 1,2,3 HAVING count(*) > 1;

-- 2) ثم أنشئ الفهرس:
CREATE UNIQUE INDEX IF NOT EXISTS uniq_active_slot
ON bookings (field_id, booking_date, booking_time)
WHERE status <> 'rejected';
