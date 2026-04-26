import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import apiClient from '../api/client';
import { ENDPOINTS } from '../api/endpoints';
import { Field } from '../types';

export function useFields(filters?: { qyteti?: string; lloji?: string }) {
  return useQuery({
    queryKey: ['fields', filters],
    queryFn: () =>
      apiClient.get<Field[]>(ENDPOINTS.FIELDS, { params: filters }).then(r => r.data),
  });
}

export function useField(id: number) {
  return useQuery({
    queryKey: ['field', id],
    queryFn: () => apiClient.get<Field>(ENDPOINTS.FIELD(id)).then(r => r.data),
    enabled: !!id,
  });
}

export function useAvailability(fieldId: number, date: string) {
  return useQuery({
    queryKey: ['availability', fieldId, date],
    queryFn: () =>
      apiClient.get<string[]>(ENDPOINTS.AVAILABILITY(fieldId), { params: { date } }).then(r => r.data),
    enabled: !!date && !!fieldId,
  });
}

export function useCreateBooking() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: (data: {
      fusha_id: number;
      data_rezervimit: string;
      ora_fillimit: string;
      ora_mbarimit: string;
    }) => apiClient.post(ENDPOINTS.BOOKINGS, data).then(r => r.data),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['availability'] });
      qc.invalidateQueries({ queryKey: ['my-bookings'] });
    },
  });
}
