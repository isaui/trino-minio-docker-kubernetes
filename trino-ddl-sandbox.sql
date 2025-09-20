-- Generated DDL for sandbox environment
-- Bucket: dtd-dw-sandbox
-- Generated on: 2025-09-19T16:29:22.780543

CREATE SCHEMA IF NOT EXISTS dtd_dw_sandbox.aggregated;

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.aggregated.academic_irs_summary (
  irs_summary_id VARCHAR
  kode_mahasiswa VARCHAR
  tahun_ajaran BIGINT
  semester BIGINT
  semester_mahasiswa BIGINT
  total_mk_diambil BIGINT
  total_mk_lulus BIGINT
  total_sks_diambil BIGINT
  total_sks_lulus BIGINT
  total_mutu_sks DOUBLE
  ips DOUBLE
  sks_kumulatif BIGINT
  mutu_sks_kumulatif DOUBLE
  ipk DOUBLE
  mk_first_attempt BIGINT
  mk_retake BIGINT
  mk_grade_improvement BIGINT
  potensi_do BOOLEAN
  eligible_graduation BOOLEAN
  hash_fingerprint BIGINT
  created_date TIMESTAMP
  updated_date TIMESTAMP
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/aggregated/academic/irs_summary/2025-07-31/'
);

CREATE SCHEMA IF NOT EXISTS dtd_dw_sandbox.cleansed;

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.cleansed.academic_irs_sort (
  kd_mhs VARCHAR
  kd_kls_mk BIGINT
  thn_ajaran BIGINT
  term BIGINT
  hash_fingerprint VARCHAR
  status DOUBLE
  timestamp TIMESTAMP
  nilai_huruf VARCHAR
  status_lulus DOUBLE
  flag_mk_luar VARCHAR
  prg_studi VARCHAR
  timestamp_nilai TIMESTAMP
  flag_dropped VARCHAR
  nilai_akhir DOUBLE
  flag_added VARCHAR
  flag_edom VARCHAR
  flag_manual VARCHAR
  id_transfer DOUBLE
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/cleansed/academic/irs/2025-08-01/sort/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.cleansed.academic_irs_new_sekali (
  kd_org VARCHAR
  nama_org_ind VARCHAR
  nm_jenjang VARCHAR
  kd_umpt VARCHAR
  nm_program_ind VARCHAR
  jns_unit_org VARCHAR
  kd_parent_org VARCHAR
  nm_sistem VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/cleansed/academic/irs_new_sekali/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.cleansed.siak_academic_irs_clean (
  kd_mhs VARCHAR
  thn_ajaran BIGINT
  term BIGINT
  status BIGINT
  timestamp TIMESTAMP
  nilai_huruf VARCHAR
  status_lulus DOUBLE
  kd_kls_mk BIGINT
  flag_mk_luar VARCHAR
  prg_studi VARCHAR
  timestamp_nilai TIMESTAMP
  flag_dropped VARCHAR
  nilai_akhir DOUBLE
  flag_added VARCHAR
  flag_edom VARCHAR
  flag_manual VARCHAR
  id_transfer DOUBLE
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/cleansed/siak/academic/irs/2025-07-29/clean/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.cleansed.siak_academic_irs_dirty (
  kd_mhs VARCHAR
  thn_ajaran BIGINT
  term BIGINT
  status BIGINT
  timestamp TIMESTAMP
  nilai_huruf VARCHAR
  status_lulus DOUBLE
  kd_kls_mk BIGINT
  flag_mk_luar VARCHAR
  prg_studi VARCHAR
  timestamp_nilai TIMESTAMP
  flag_dropped VARCHAR
  nilai_akhir DOUBLE
  flag_added VARCHAR
  flag_edom VARCHAR
  flag_manual VARCHAR
  id_transfer DOUBLE
  duplicate_reason VARCHAR
  duplicate_group_id VARCHAR
  is_kept_record BOOLEAN
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/cleansed/siak/academic/irs/2025-07-29/dirty/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.cleansed.siakng_dosen_clean (
  nip VARCHAR
  nama_dosen VARCHAR
  kd_org VARCHAR
  aktif VARCHAR
  skema_id DOUBLE
  nama_skema VARCHAR
  maks_sks DOUBLE
  nm_dosen VARCHAR
  ldap_acc VARCHAR
  nidn VARCHAR
  jabatan VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/cleansed/siakng/dosen/2025-08-01/clean/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.cleansed.siakng_dosen_hash (
  nip VARCHAR
  hash_fingerprint VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/cleansed/siakng/dosen/2025-08-01/hash/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.cleansed.siakng_dosen_sort (
  nip VARCHAR
  nama_dosen VARCHAR
  kd_org VARCHAR
  aktif VARCHAR
  skema_id DOUBLE
  nama_skema VARCHAR
  maks_sks DOUBLE
  nm_dosen VARCHAR
  ldap_acc VARCHAR
  nidn VARCHAR
  jabatan VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/cleansed/siakng/dosen/2025-08-01/sort/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.cleansed.siakng_irs_clean (
  kd_mhs VARCHAR
  thn_ajaran BIGINT
  term BIGINT
  status BIGINT
  timestamp TIMESTAMP
  nilai_huruf VARCHAR
  status_lulus DOUBLE
  kd_kls_mk BIGINT
  flag_mk_luar VARCHAR
  prg_studi VARCHAR
  timestamp_nilai TIMESTAMP
  flag_dropped VARCHAR
  nilai_akhir DOUBLE
  flag_added VARCHAR
  flag_edom VARCHAR
  flag_manual VARCHAR
  id_transfer DOUBLE
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/cleansed/siakng/irs/2025-07-30/clean/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.cleansed.siakng_irs_dirty (
  kd_mhs VARCHAR
  thn_ajaran BIGINT
  term BIGINT
  status BIGINT
  timestamp TIMESTAMP
  nilai_huruf VARCHAR
  status_lulus DOUBLE
  kd_kls_mk BIGINT
  flag_mk_luar VARCHAR
  prg_studi VARCHAR
  timestamp_nilai TIMESTAMP
  flag_dropped VARCHAR
  nilai_akhir DOUBLE
  flag_added VARCHAR
  flag_edom VARCHAR
  flag_manual VARCHAR
  id_transfer DOUBLE
  duplicate_reason VARCHAR
  is_kept_record BOOLEAN
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/cleansed/siakng/irs/2025-07-30/dirty/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.cleansed.siakng_irs_hash (
  kd_mhs VARCHAR
  kd_kls_mk BIGINT
  thn_ajaran BIGINT
  term BIGINT
  hash_fingerprint VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/cleansed/siakng/irs/2025-07-30/hash/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.cleansed.siakng_irs_sort (
  kd_mhs VARCHAR
  thn_ajaran BIGINT
  term BIGINT
  status BIGINT
  timestamp TIMESTAMP
  nilai_huruf VARCHAR
  status_lulus DOUBLE
  kd_kls_mk BIGINT
  flag_mk_luar VARCHAR
  prg_studi VARCHAR
  timestamp_nilai TIMESTAMP
  flag_dropped VARCHAR
  nilai_akhir DOUBLE
  flag_added VARCHAR
  flag_edom VARCHAR
  flag_manual VARCHAR
  id_transfer DOUBLE
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/cleansed/siakng/irs/2025-07-30/sort/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.cleansed.siakng_irs_changes (
  kd_mhs VARCHAR
  thn_ajaran BIGINT
  term BIGINT
  status BIGINT
  timestamp TIMESTAMP
  nilai_huruf VARCHAR
  status_lulus DOUBLE
  kd_kls_mk BIGINT
  flag_mk_luar VARCHAR
  prg_studi VARCHAR
  timestamp_nilai TIMESTAMP
  flag_dropped VARCHAR
  nilai_akhir DOUBLE
  flag_added VARCHAR
  flag_edom VARCHAR
  flag_manual VARCHAR
  id_transfer DOUBLE
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/cleansed/siakng/irs/2025-08-01/changes/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.cleansed.siakng_irs_clean (
  kd_mhs VARCHAR
  thn_ajaran BIGINT
  term BIGINT
  status BIGINT
  timestamp TIMESTAMP
  nilai_huruf VARCHAR
  status_lulus DOUBLE
  kd_kls_mk BIGINT
  flag_mk_luar VARCHAR
  prg_studi VARCHAR
  timestamp_nilai TIMESTAMP
  flag_dropped VARCHAR
  nilai_akhir DOUBLE
  flag_added VARCHAR
  flag_edom VARCHAR
  flag_manual VARCHAR
  id_transfer DOUBLE
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/cleansed/siakng/irs/2025-08-01/clean/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.cleansed.siakng_irs_dirty (
  kd_mhs VARCHAR
  thn_ajaran BIGINT
  term BIGINT
  status BIGINT
  timestamp TIMESTAMP
  nilai_huruf VARCHAR
  status_lulus DOUBLE
  kd_kls_mk BIGINT
  flag_mk_luar VARCHAR
  prg_studi VARCHAR
  timestamp_nilai TIMESTAMP
  flag_dropped VARCHAR
  nilai_akhir DOUBLE
  flag_added VARCHAR
  flag_edom VARCHAR
  flag_manual VARCHAR
  id_transfer DOUBLE
  duplicate_reason VARCHAR
  is_kept_record BOOLEAN
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/cleansed/siakng/irs/2025-08-01/dirty/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.cleansed.siakng_irs_hash (
  kd_mhs VARCHAR
  kd_kls_mk BIGINT
  thn_ajaran BIGINT
  term BIGINT
  hash_fingerprint VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/cleansed/siakng/irs/2025-08-01/hash/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.cleansed.siakng_irs_sort (
  kd_mhs VARCHAR
  thn_ajaran BIGINT
  term BIGINT
  status BIGINT
  timestamp TIMESTAMP
  nilai_huruf VARCHAR
  status_lulus DOUBLE
  kd_kls_mk BIGINT
  flag_mk_luar VARCHAR
  prg_studi VARCHAR
  timestamp_nilai TIMESTAMP
  flag_dropped VARCHAR
  nilai_akhir DOUBLE
  flag_added VARCHAR
  flag_edom VARCHAR
  flag_manual VARCHAR
  id_transfer DOUBLE
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/cleansed/siakng/irs/2025-08-01/sort/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.cleansed.siakng_irs_changes (
  kd_mhs VARCHAR
  thn_ajaran BIGINT
  term BIGINT
  status BIGINT
  timestamp TIMESTAMP
  nilai_huruf VARCHAR
  status_lulus DOUBLE
  kd_kls_mk BIGINT
  flag_mk_luar VARCHAR
  prg_studi VARCHAR
  timestamp_nilai TIMESTAMP
  flag_dropped VARCHAR
  nilai_akhir DOUBLE
  flag_added VARCHAR
  flag_edom VARCHAR
  flag_manual VARCHAR
  id_transfer DOUBLE
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/cleansed/siakng/irs/2025-08-03/changes/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.cleansed.siakng_kelas_mata_kuliah_clean (
  kd_kls_mk BIGINT
  term BIGINT
  kd_mk VARCHAR
  kd_kur VARCHAR
  koord_kls_mk VARCHAR
  jml_mhs_terdaftar DOUBLE
  kapasitas_kelas DOUBLE
  jenis_kelas BIGINT
  nm_kls_mk VARCHAR
  thn BIGINT
  status VARCHAR
  show_letter VARCHAR
  flag_transfer BIGINT
  tujuan_kls_mk VARCHAR
  kd_unit_adm VARCHAR
  tujuan_kls_mk_ing VARCHAR
  kd_bhs BIGINT
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/cleansed/siakng/kelas_mata_kuliah/2025-08-01/clean/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.cleansed.siakng_kelas_mata_kuliah_hash (
  kd_kls_mk BIGINT
  hash_fingerprint VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/cleansed/siakng/kelas_mata_kuliah/2025-08-01/hash/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.cleansed.siakng_kelas_mata_kuliah_sort (
  kd_kls_mk BIGINT
  term BIGINT
  kd_mk VARCHAR
  kd_kur VARCHAR
  koord_kls_mk VARCHAR
  jml_mhs_terdaftar DOUBLE
  kapasitas_kelas DOUBLE
  jenis_kelas BIGINT
  nm_kls_mk VARCHAR
  thn BIGINT
  status VARCHAR
  show_letter VARCHAR
  flag_transfer BIGINT
  tujuan_kls_mk VARCHAR
  kd_unit_adm VARCHAR
  tujuan_kls_mk_ing VARCHAR
  kd_bhs BIGINT
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/cleansed/siakng/kelas_mata_kuliah/2025-08-01/sort/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.cleansed.siakng_mata_kuliah_clean (
  kd_mk VARCHAR
  kd_kur VARCHAR
  nm_mk VARCHAR
  nm_singkat_mk_ind VARCHAR
  nm_singkat_mk_ing VARCHAR
  jml_sks BIGINT
  kd_jenis_mk DOUBLE
  silabus VARCHAR
  lingkup BIGINT
  ipk_min DOUBLE
  untuk_term BIGINT
  flag_mk_spesial BIGINT
  sks_min DOUBLE
  nm_mk_ing VARCHAR
  equality_list VARCHAR
  kd_sk VARCHAR
  class_type BIGINT
  silabus_ing VARCHAR
  flag_mk_spesial_final VARCHAR
  kd_evalmk DOUBLE
  equality_list2 VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/cleansed/siakng/mata_kuliah/2025-08-01/clean/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.cleansed.siakng_mata_kuliah_hash (
  kd_mk VARCHAR
  kd_kur VARCHAR
  hash_fingerprint VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/cleansed/siakng/mata_kuliah/2025-08-01/hash/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.cleansed.siakng_mata_kuliah_sort (
  kd_mk VARCHAR
  kd_kur VARCHAR
  nm_mk VARCHAR
  nm_singkat_mk_ind VARCHAR
  nm_singkat_mk_ing VARCHAR
  jml_sks BIGINT
  kd_jenis_mk DOUBLE
  silabus VARCHAR
  lingkup BIGINT
  ipk_min DOUBLE
  untuk_term BIGINT
  flag_mk_spesial BIGINT
  sks_min DOUBLE
  nm_mk_ing VARCHAR
  equality_list VARCHAR
  kd_sk VARCHAR
  class_type BIGINT
  silabus_ing VARCHAR
  flag_mk_spesial_final VARCHAR
  kd_evalmk DOUBLE
  equality_list2 VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/cleansed/siakng/mata_kuliah/2025-08-01/sort/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.cleansed.siakng_prodi_clean (
  kd_org VARCHAR
  nama_org_ind VARCHAR
  nama_org_ing VARCHAR
  no_organisasi VARCHAR
  alamat VARCHAR
  pemimpin_organisasi VARCHAR
  kd_lokasi DOUBLE
  telp VARCHAR
  fax VARCHAR
  email VARCHAR
  contact VARCHAR
  kd_jenjang VARCHAR
  kd_umpt VARCHAR
  kd_prg_pendidikan VARCHAR
  kd_jenis_org BIGINT
  kd_parent_org VARCHAR
  kd_dikti VARCHAR
  kd_jenis_sistem BIGINT
  nama_org_singkat VARCHAR
  mapping_ruangan VARCHAR
  active VARCHAR
  decree_no VARCHAR
  decree_until TIMESTAMP
  approved VARCHAR
  kd_surat VARCHAR
  kd_peringkat VARCHAR
  sk_peringkat VARCHAR
  exp_peringkat TIMESTAMP
  pmn_grc VARCHAR
  pmn_trc VARCHAR
  nilai_peringkat DOUBLE
  no_sertifikat VARCHAR
  tgl_sk_peringkat TIMESTAMP
  masa_studi DOUBLE
  normal_terms DOUBLE
  id_prodi_dikti VARCHAR
  pp_kd_program VARCHAR
  pp_nm_program_ind VARCHAR
  pp_nm_program_ing VARCHAR
  pp_kd_dikti VARCHAR
  pp_masa_studi DOUBLE
  pp_kd_jenjang VARCHAR
  pp_normal_terms DOUBLE
  pp_urutan BIGINT
  pp_f_obm BIGINT
  jn_kd_jenjang VARCHAR
  jn_nm_jenjang VARCHAR
  jn_nm_jenjang_ing VARCHAR
  jn_jns_gelar VARCHAR
  jn_up_ipk_cumlaude DOUBLE
  jn_urutan BIGINT
  jn_id_pddikti VARCHAR
  jn_flag_nina BIGINT
  jn_normal_terms BIGINT
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/cleansed/siakng/prodi/2025-08-01/clean/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.cleansed.siakng_prodi_hash (
  kd_org VARCHAR
  hash_fingerprint VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/cleansed/siakng/prodi/2025-08-01/hash/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.cleansed.siakng_prodi_sort (
  kd_org VARCHAR
  nama_org_ind VARCHAR
  nama_org_ing VARCHAR
  no_organisasi VARCHAR
  alamat VARCHAR
  pemimpin_organisasi VARCHAR
  kd_lokasi DOUBLE
  telp VARCHAR
  fax VARCHAR
  email VARCHAR
  contact VARCHAR
  kd_jenjang VARCHAR
  kd_umpt VARCHAR
  kd_prg_pendidikan VARCHAR
  kd_jenis_org BIGINT
  kd_parent_org VARCHAR
  kd_dikti VARCHAR
  kd_jenis_sistem BIGINT
  nama_org_singkat VARCHAR
  mapping_ruangan VARCHAR
  active VARCHAR
  decree_no VARCHAR
  decree_until TIMESTAMP
  approved VARCHAR
  kd_surat VARCHAR
  kd_peringkat VARCHAR
  sk_peringkat VARCHAR
  exp_peringkat TIMESTAMP
  pmn_grc VARCHAR
  pmn_trc VARCHAR
  nilai_peringkat DOUBLE
  no_sertifikat VARCHAR
  tgl_sk_peringkat TIMESTAMP
  masa_studi DOUBLE
  normal_terms DOUBLE
  id_prodi_dikti VARCHAR
  pp_kd_program VARCHAR
  pp_nm_program_ind VARCHAR
  pp_nm_program_ing VARCHAR
  pp_kd_dikti VARCHAR
  pp_masa_studi DOUBLE
  pp_kd_jenjang VARCHAR
  pp_normal_terms DOUBLE
  pp_urutan BIGINT
  pp_f_obm BIGINT
  jn_kd_jenjang VARCHAR
  jn_nm_jenjang VARCHAR
  jn_nm_jenjang_ing VARCHAR
  jn_jns_gelar VARCHAR
  jn_up_ipk_cumlaude DOUBLE
  jn_urutan BIGINT
  jn_id_pddikti VARCHAR
  jn_flag_nina BIGINT
  jn_normal_terms BIGINT
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/cleansed/siakng/prodi/2025-08-01/sort/'
);

CREATE SCHEMA IF NOT EXISTS dtd_dw_sandbox.conformed;

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.conformed.academic_akreditasi-prodi-invalid (
  perguruan_tinggi VARCHAR
  program_studi VARCHAR
  strata VARCHAR
  wilayah VARCHAR
  no_sk VARCHAR
  tahun_sk VARCHAR
  peringkat VARCHAR
  expired VARCHAR
  note VARCHAR
  kode_program_studi VARCHAR
  reason VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/conformed/academic/akreditasi-prodi-invalid/2025-09-11/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.conformed.academic_akreditasi-prodi-invalid (
  perguruan_tinggi VARCHAR
  program_studi VARCHAR
  strata VARCHAR
  wilayah VARCHAR
  no_sk VARCHAR
  tahun_sk VARCHAR
  peringkat VARCHAR
  expired VARCHAR
  note VARCHAR
  kode_program_studi VARCHAR
  reason VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/conformed/academic/akreditasi-prodi-invalid/2025-09-12/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.conformed.academic_akreditasi-prodi (
  perguruan_tinggi VARCHAR
  program_studi VARCHAR
  strata VARCHAR
  wilayah VARCHAR
  no_sk VARCHAR
  tahun_sk VARCHAR
  peringkat VARCHAR
  expired VARCHAR
  note VARCHAR
  kode_program_studi VARCHAR
  reason VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/conformed/academic/akreditasi-prodi/2025-09-11/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.conformed.academic_akreditasi-prodi (
  perguruan_tinggi VARCHAR
  program_studi VARCHAR
  strata VARCHAR
  wilayah VARCHAR
  no_sk VARCHAR
  tahun_sk VARCHAR
  peringkat VARCHAR
  expired VARCHAR
  note VARCHAR
  kode_program_studi VARCHAR
  reason VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/conformed/academic/akreditasi-prodi/2025-09-12/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.conformed.academic_program-studi (
  -- Schema detection failed, please update manually
  id BIGINT
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/conformed/academic/program-studi/2025-07-08/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.conformed.academic_program-studi (
  kode_program_studi VARCHAR
  nama_program_studi VARCHAR
  nama_program_studi_eng VARCHAR
  kode_program_pendidikan VARCHAR
  nama_program_pendidikan VARCHAR
  nama_program_pendidikan_eng VARCHAR
  kode_dikti_pp VARCHAR
  masa_studi_pp DOUBLE
  masa_studi_normal_program_pendidikan BIGINT
  urutan BIGINT
  kode_fakultas VARCHAR
  nama_fakultas VARCHAR
  nama_fakultas_eng VARCHAR
  kode_fakultas_singkat VARCHAR
  nama_fakultas_singkat VARCHAR
  kode_departemen VARCHAR
  nama_departemen VARCHAR
  nama_departemen_eng VARCHAR
  nomor_organisasi VARCHAR
  alamat_organisasi VARCHAR
  nama_pemimpin_organisasi VARCHAR
  kode_lokasi BIGINT
  kontak_organisasi VARCHAR
  kode_umpt VARCHAR
  kode_parent_program_studi VARCHAR
  kode_jenis_sistem BIGINT
  nomor_program_studi_singkat VARCHAR
  pemetaan_ruangan VARCHAR
  status_aktif BIGINT
  nomor_surat_keputusan VARCHAR
  masa_berlaku_surat_keputusan TIMESTAMP
  status_disetujui BIGINT
  kode_surat VARCHAR
  kode_peringkat VARCHAR
  sk_peringkat VARCHAR
  masa_berlaku_peringkat TIMESTAMP
  pmn_grc BIGINT
  pmn_trc BIGINT
  nilai_peringkat BIGINT
  no_sertifikat VARCHAR
  tanggal_sk_peringkat TIMESTAMP
  kode_jenjang BIGINT
  nama_jenjang VARCHAR
  nama_jenjang_eng VARCHAR
  jenis_gelar VARCHAR
  up_ipk_cumlaude DOUBLE
  urutan_jn BIGINT
  id_pddikti VARCHAR
  flag_nina BOOLEAN
  email_organisasi VARCHAR
  f_obm BIGINT
  id_program_studi_dikti VARCHAR
  kode_dikti VARCHAR
  kode_jenis_unit_organisasi BIGINT
  kode_jenjang_jn BIGINT
  masa_studi BIGINT
  masa_studi_normal_jenjang BIGINT
  nama_program_studi_lengkap VARCHAR
  nama_program_studi_lengkap_eng VARCHAR
  nomor_fax_organisasi VARCHAR
  nomor_telepon_organisasi VARCHAR
  __null_dask_index__ BIGINT
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/conformed/academic/program-studi/2025-09-08/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.conformed.akreditasi (
  program_studi VARCHAR
  jenjang VARCHAR
  fakultas VARCHAR
  tahun_akreditasi INTEGER
  peringkat VARCHAR
  sk VARCHAR
  tanggal_berakhir VARCHAR
  tahun_berakhir INTEGER
  is_active BIGINT
  is_expired BIGINT
  is_terakreditasi INTEGER
  jenis_program VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/conformed/akreditasi/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.conformed.edom_edom-isian-agg (
  edom_isian_agg_sk VARCHAR
  kode_kelas_mata_kuliah BIGINT
  nip VARCHAR
  id_grup_pertanyaan BIGINT
  nilai_mean DOUBLE
  nilai_sum BIGINT
  nilai_count BIGINT
  kelas_mata_kuliah_sk BIGINT
  tahun_akademik SMALLINT
  semester_akademik BIGINT
  kode_mata_kuliah VARCHAR
  kode_kurikulum VARCHAR
  __null_dask_index__ BIGINT
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/conformed/edom/edom-isian-agg/2025-08-09/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.conformed.edom_irs-new-sekali (
  nilai_mk VARCHAR
  mutu_nilai DOUBLE
  complete VARCHAR
  occurence VARCHAR
  count_ip VARCHAR
  status_lulus BIGINT
  range_score VARCHAR
  default_range_min DOUBLE
  default_range_max DOUBLE
  count_credits VARCHAR
  count_pdpt VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/conformed/edom/irs-new-sekali/2025-08-09/'
);

CREATE SCHEMA IF NOT EXISTS dtd_dw_sandbox.edom-isian-agg-conformed;

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.edom-isian-agg-conformed.default (
  edom_isian_agg_sk VARCHAR
  kode_kelas_mata_kuliah BIGINT
  nip VARCHAR
  id_grup_pertanyaan BIGINT
  nilai_mean DOUBLE
  nilai_sum BIGINT
  nilai_count BIGINT
  kelas_mata_kuliah_sk BIGINT
  tahun_akademik SMALLINT
  semester_akademik BIGINT
  kode_mata_kuliah VARCHAR
  kode_kurikulum VARCHAR
  __null_dask_index__ BIGINT
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/edom-isian-agg-conformed/2025-08-09/'
);

CREATE SCHEMA IF NOT EXISTS dtd_dw_sandbox.incremental;

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.incremental.siakng_dosen_hash (
  nip VARCHAR
  hash_fingerprint VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/incremental/siakng/dosen/2025-07-31/hash/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.incremental.siakng_dosen (
  nip VARCHAR
  nama_dosen VARCHAR
  kd_org VARCHAR
  aktif VARCHAR
  skema_id DOUBLE
  nama_skema VARCHAR
  maks_sks DOUBLE
  nm_dosen VARCHAR
  ldap_acc VARCHAR
  nidn VARCHAR
  jabatan VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/incremental/siakng/dosen/2025-07-31/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.incremental.siakng_irs_hash (
  kd_mhs VARCHAR
  kd_kls_mk BIGINT
  thn_ajaran BIGINT
  term BIGINT
  hash_fingerprint VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/incremental/siakng/irs/2025-07-31/hash/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.incremental.siakng_irs (
  kd_mhs VARCHAR
  thn_ajaran BIGINT
  term BIGINT
  status BIGINT
  timestamp TIMESTAMP
  nilai_huruf VARCHAR
  status_lulus DOUBLE
  kd_kls_mk BIGINT
  flag_mk_luar VARCHAR
  prg_studi VARCHAR
  timestamp_nilai TIMESTAMP
  flag_dropped VARCHAR
  nilai_akhir DOUBLE
  flag_added VARCHAR
  flag_edom VARCHAR
  flag_manual VARCHAR
  id_transfer DOUBLE
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/incremental/siakng/irs/2025-07-31/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.incremental.siakng_kelas_mata_kuliah_hash (
  kd_kls_mk BIGINT
  hash_fingerprint VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/incremental/siakng/kelas_mata_kuliah/2025-07-31/hash/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.incremental.siakng_kelas_mata_kuliah (
  kd_kls_mk BIGINT
  term BIGINT
  kd_mk VARCHAR
  kd_kur VARCHAR
  koord_kls_mk VARCHAR
  jml_mhs_terdaftar DOUBLE
  kapasitas_kelas DOUBLE
  jenis_kelas BIGINT
  nm_kls_mk VARCHAR
  thn BIGINT
  status VARCHAR
  show_letter VARCHAR
  flag_transfer BIGINT
  tujuan_kls_mk VARCHAR
  kd_unit_adm VARCHAR
  tujuan_kls_mk_ing VARCHAR
  kd_bhs BIGINT
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/incremental/siakng/kelas_mata_kuliah/2025-07-31/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.incremental.siakng_mata_kuliah_hash (
  kd_mk VARCHAR
  kd_kur VARCHAR
  hash_fingerprint VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/incremental/siakng/mata_kuliah/2025-07-31/hash/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.incremental.siakng_mata_kuliah (
  kd_mk VARCHAR
  kd_kur VARCHAR
  nm_mk VARCHAR
  nm_singkat_mk_ind VARCHAR
  nm_singkat_mk_ing VARCHAR
  jml_sks BIGINT
  kd_jenis_mk DOUBLE
  silabus VARCHAR
  lingkup BIGINT
  ipk_min DOUBLE
  untuk_term BIGINT
  flag_mk_spesial BIGINT
  sks_min DOUBLE
  nm_mk_ing VARCHAR
  equality_list VARCHAR
  kd_sk VARCHAR
  class_type BIGINT
  silabus_ing VARCHAR
  flag_mk_spesial_final VARCHAR
  kd_evalmk DOUBLE
  equality_list2 VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/incremental/siakng/mata_kuliah/2025-07-31/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.incremental.siakng_prodi_hash (
  kd_org VARCHAR
  hash_fingerprint VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/incremental/siakng/prodi/2025-07-31/hash/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.incremental.siakng_prodi (
  kd_org VARCHAR
  nama_org_ind VARCHAR
  nama_org_ing VARCHAR
  no_organisasi VARCHAR
  alamat VARCHAR
  pemimpin_organisasi VARCHAR
  kd_lokasi DOUBLE
  telp VARCHAR
  fax VARCHAR
  email VARCHAR
  contact VARCHAR
  kd_jenjang VARCHAR
  kd_umpt VARCHAR
  kd_prg_pendidikan VARCHAR
  kd_jenis_org BIGINT
  kd_parent_org VARCHAR
  kd_dikti VARCHAR
  kd_jenis_sistem BIGINT
  nama_org_singkat VARCHAR
  mapping_ruangan VARCHAR
  active VARCHAR
  decree_no VARCHAR
  decree_until TIMESTAMP
  approved VARCHAR
  kd_surat VARCHAR
  kd_peringkat VARCHAR
  sk_peringkat VARCHAR
  exp_peringkat TIMESTAMP
  pmn_grc VARCHAR
  pmn_trc VARCHAR
  nilai_peringkat DOUBLE
  no_sertifikat VARCHAR
  tgl_sk_peringkat TIMESTAMP
  masa_studi DOUBLE
  normal_terms DOUBLE
  id_prodi_dikti VARCHAR
  pp_kd_program VARCHAR
  pp_nm_program_ind VARCHAR
  pp_nm_program_ing VARCHAR
  pp_kd_dikti VARCHAR
  pp_masa_studi DOUBLE
  pp_kd_jenjang VARCHAR
  pp_normal_terms DOUBLE
  pp_urutan BIGINT
  pp_f_obm BIGINT
  jn_kd_jenjang VARCHAR
  jn_nm_jenjang VARCHAR
  jn_nm_jenjang_ing VARCHAR
  jn_jns_gelar VARCHAR
  jn_up_ipk_cumlaude DOUBLE
  jn_urutan BIGINT
  jn_id_pddikti VARCHAR
  jn_flag_nina BIGINT
  jn_normal_terms BIGINT
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/incremental/siakng/prodi/2025-07-31/'
);

CREATE SCHEMA IF NOT EXISTS dtd_dw_sandbox.landing;

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.landing.siakng_dosen (
  nip VARCHAR
  nama_dosen VARCHAR
  kd_org VARCHAR
  aktif VARCHAR
  skema_id DOUBLE
  nama_skema VARCHAR
  maks_sks DOUBLE
  nm_dosen VARCHAR
  ldap_acc VARCHAR
  nidn VARCHAR
  jabatan VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/landing/siakng/dosen/2025-07-24/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.landing.siakng_dosen (
  nip VARCHAR
  nama_dosen VARCHAR
  kd_org VARCHAR
  aktif VARCHAR
  skema_id DOUBLE
  nama_skema VARCHAR
  maks_sks DOUBLE
  nm_dosen VARCHAR
  ldap_acc VARCHAR
  nidn VARCHAR
  jabatan VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/landing/siakng/dosen/2025-08-01/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.landing.siakng_irs (
  kd_mhs VARCHAR
  thn_ajaran BIGINT
  term BIGINT
  status BIGINT
  timestamp TIMESTAMP
  nilai_huruf VARCHAR
  status_lulus DOUBLE
  kd_kls_mk BIGINT
  flag_mk_luar VARCHAR
  prg_studi VARCHAR
  timestamp_nilai TIMESTAMP
  flag_dropped VARCHAR
  nilai_akhir DOUBLE
  flag_added VARCHAR
  flag_edom VARCHAR
  flag_manual VARCHAR
  id_transfer DOUBLE
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/landing/siakng/irs/2025-07-24/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.landing.siakng_irs (
  kd_mhs VARCHAR
  thn_ajaran BIGINT
  term BIGINT
  status BIGINT
  timestamp TIMESTAMP
  nilai_huruf VARCHAR
  status_lulus DOUBLE
  kd_kls_mk BIGINT
  flag_mk_luar VARCHAR
  prg_studi VARCHAR
  timestamp_nilai TIMESTAMP
  flag_dropped VARCHAR
  nilai_akhir DOUBLE
  flag_added VARCHAR
  flag_edom VARCHAR
  flag_manual VARCHAR
  id_transfer DOUBLE
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/landing/siakng/irs/2025-08-01/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.landing.siakng_kelas_mata_kuliah (
  kd_kls_mk BIGINT
  term BIGINT
  kd_mk VARCHAR
  kd_kur VARCHAR
  koord_kls_mk VARCHAR
  jml_mhs_terdaftar DOUBLE
  kapasitas_kelas DOUBLE
  jenis_kelas BIGINT
  nm_kls_mk VARCHAR
  thn BIGINT
  status VARCHAR
  show_letter VARCHAR
  flag_transfer BIGINT
  tujuan_kls_mk VARCHAR
  kd_unit_adm VARCHAR
  tujuan_kls_mk_ing VARCHAR
  kd_bhs BIGINT
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/landing/siakng/kelas_mata_kuliah/2025-07-24/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.landing.siakng_kelas_mata_kuliah (
  kd_kls_mk BIGINT
  term BIGINT
  kd_mk VARCHAR
  kd_kur VARCHAR
  koord_kls_mk VARCHAR
  jml_mhs_terdaftar DOUBLE
  kapasitas_kelas DOUBLE
  jenis_kelas BIGINT
  nm_kls_mk VARCHAR
  thn BIGINT
  status VARCHAR
  show_letter VARCHAR
  flag_transfer BIGINT
  tujuan_kls_mk VARCHAR
  kd_unit_adm VARCHAR
  tujuan_kls_mk_ing VARCHAR
  kd_bhs BIGINT
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/landing/siakng/kelas_mata_kuliah/2025-08-01/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.landing.siakng_mata_kuliah (
  kd_mk VARCHAR
  kd_kur VARCHAR
  nm_mk VARCHAR
  nm_singkat_mk_ind VARCHAR
  nm_singkat_mk_ing VARCHAR
  jml_sks BIGINT
  kd_jenis_mk DOUBLE
  silabus VARCHAR
  lingkup BIGINT
  ipk_min DOUBLE
  untuk_term BIGINT
  flag_mk_spesial BIGINT
  sks_min DOUBLE
  nm_mk_ing VARCHAR
  equality_list VARCHAR
  kd_sk VARCHAR
  class_type BIGINT
  silabus_ing VARCHAR
  flag_mk_spesial_final VARCHAR
  kd_evalmk DOUBLE
  equality_list2 VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/landing/siakng/mata_kuliah/2025-07-24/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.landing.siakng_mata_kuliah (
  kd_mk VARCHAR
  kd_kur VARCHAR
  nm_mk VARCHAR
  nm_singkat_mk_ind VARCHAR
  nm_singkat_mk_ing VARCHAR
  jml_sks BIGINT
  kd_jenis_mk DOUBLE
  silabus VARCHAR
  lingkup BIGINT
  ipk_min DOUBLE
  untuk_term BIGINT
  flag_mk_spesial BIGINT
  sks_min DOUBLE
  nm_mk_ing VARCHAR
  equality_list VARCHAR
  kd_sk VARCHAR
  class_type BIGINT
  silabus_ing VARCHAR
  flag_mk_spesial_final VARCHAR
  kd_evalmk DOUBLE
  equality_list2 VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/landing/siakng/mata_kuliah/2025-08-01/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.landing.siakng_prodi (
  kd_org VARCHAR
  nama_org_ind VARCHAR
  nama_org_ing VARCHAR
  no_organisasi VARCHAR
  alamat VARCHAR
  pemimpin_organisasi VARCHAR
  kd_lokasi DOUBLE
  telp VARCHAR
  fax VARCHAR
  email VARCHAR
  contact VARCHAR
  kd_jenjang VARCHAR
  kd_umpt VARCHAR
  kd_prg_pendidikan VARCHAR
  kd_jenis_org BIGINT
  kd_parent_org VARCHAR
  kd_dikti VARCHAR
  kd_jenis_sistem BIGINT
  nama_org_singkat VARCHAR
  mapping_ruangan VARCHAR
  active VARCHAR
  decree_no VARCHAR
  decree_until TIMESTAMP
  approved VARCHAR
  kd_surat VARCHAR
  kd_peringkat VARCHAR
  sk_peringkat VARCHAR
  exp_peringkat TIMESTAMP
  pmn_grc VARCHAR
  pmn_trc VARCHAR
  nilai_peringkat DOUBLE
  no_sertifikat VARCHAR
  tgl_sk_peringkat TIMESTAMP
  masa_studi DOUBLE
  normal_terms DOUBLE
  id_prodi_dikti VARCHAR
  pp_kd_program VARCHAR
  pp_nm_program_ind VARCHAR
  pp_nm_program_ing VARCHAR
  pp_kd_dikti VARCHAR
  pp_masa_studi DOUBLE
  pp_kd_jenjang VARCHAR
  pp_normal_terms DOUBLE
  pp_urutan BIGINT
  pp_f_obm BIGINT
  jn_kd_jenjang VARCHAR
  jn_nm_jenjang VARCHAR
  jn_nm_jenjang_ing VARCHAR
  jn_jns_gelar VARCHAR
  jn_up_ipk_cumlaude DOUBLE
  jn_urutan BIGINT
  jn_id_pddikti VARCHAR
  jn_flag_nina BIGINT
  jn_normal_terms BIGINT
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/landing/siakng/prodi/2025-07-24/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.landing.siakng_prodi (
  kd_org VARCHAR
  nama_org_ind VARCHAR
  nama_org_ing VARCHAR
  no_organisasi VARCHAR
  alamat VARCHAR
  pemimpin_organisasi VARCHAR
  kd_lokasi DOUBLE
  telp VARCHAR
  fax VARCHAR
  email VARCHAR
  contact VARCHAR
  kd_jenjang VARCHAR
  kd_umpt VARCHAR
  kd_prg_pendidikan VARCHAR
  kd_jenis_org BIGINT
  kd_parent_org VARCHAR
  kd_dikti VARCHAR
  kd_jenis_sistem BIGINT
  nama_org_singkat VARCHAR
  mapping_ruangan VARCHAR
  active VARCHAR
  decree_no VARCHAR
  decree_until TIMESTAMP
  approved VARCHAR
  kd_surat VARCHAR
  kd_peringkat VARCHAR
  sk_peringkat VARCHAR
  exp_peringkat TIMESTAMP
  pmn_grc VARCHAR
  pmn_trc VARCHAR
  nilai_peringkat DOUBLE
  no_sertifikat VARCHAR
  tgl_sk_peringkat TIMESTAMP
  masa_studi DOUBLE
  normal_terms DOUBLE
  id_prodi_dikti VARCHAR
  pp_kd_program VARCHAR
  pp_nm_program_ind VARCHAR
  pp_nm_program_ing VARCHAR
  pp_kd_dikti VARCHAR
  pp_masa_studi DOUBLE
  pp_kd_jenjang VARCHAR
  pp_normal_terms DOUBLE
  pp_urutan BIGINT
  pp_f_obm BIGINT
  jn_kd_jenjang VARCHAR
  jn_nm_jenjang VARCHAR
  jn_nm_jenjang_ing VARCHAR
  jn_jns_gelar VARCHAR
  jn_up_ipk_cumlaude DOUBLE
  jn_urutan BIGINT
  jn_id_pddikti VARCHAR
  jn_flag_nina BIGINT
  jn_normal_terms BIGINT
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/landing/siakng/prodi/2025-08-01/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.landing.siakng_tlu_jenis_kelas (
  kd_jenis_kelas BIGINT
  nm_jenis_kelas VARCHAR
  aktif VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/landing/siakng/tlu_jenis_kelas/2025-07-24/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.landing.siakng_tlu_jenis_kelas (
  kd_jenis_kelas BIGINT
  nm_jenis_kelas VARCHAR
  aktif VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/landing/siakng/tlu_jenis_kelas/2025-07-31/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.landing.siakng_tlu_jenis_kelas (
  kd_jenis_kelas BIGINT
  nm_jenis_kelas VARCHAR
  aktif VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/landing/siakng/tlu_jenis_kelas/2025-08-01/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.landing.siakng_tlu_mutu_nilai (
  nilai_mk VARCHAR
  mutu_nilai DOUBLE
  complete VARCHAR
  occurence VARCHAR
  count_ip VARCHAR
  status_lulus BIGINT
  range_score VARCHAR
  default_range_min DOUBLE
  default_range_max DOUBLE
  count_credits VARCHAR
  count_pdpt VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/landing/siakng/tlu_mutu_nilai/2025-07-24/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.landing.siakng_tlu_mutu_nilai (
  nilai_mk VARCHAR
  mutu_nilai DOUBLE
  complete VARCHAR
  occurence VARCHAR
  count_ip VARCHAR
  status_lulus BIGINT
  range_score VARCHAR
  default_range_min DOUBLE
  default_range_max DOUBLE
  count_credits VARCHAR
  count_pdpt VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/landing/siakng/tlu_mutu_nilai/2025-07-31/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.landing.siakng_tlu_mutu_nilai (
  nilai_mk VARCHAR
  mutu_nilai DOUBLE
  complete VARCHAR
  occurence VARCHAR
  count_ip VARCHAR
  status_lulus BIGINT
  range_score VARCHAR
  default_range_min DOUBLE
  default_range_max DOUBLE
  count_credits VARCHAR
  count_pdpt VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/landing/siakng/tlu_mutu_nilai/2025-08-01/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.landing.siakng_tlu_status_irs (
  kd_status BIGINT
  nm_status_ind VARCHAR
  nm_status_ing VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/landing/siakng/tlu_status_irs/2025-07-24/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.landing.siakng_tlu_status_irs (
  kd_status BIGINT
  nm_status_ind VARCHAR
  nm_status_ing VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/landing/siakng/tlu_status_irs/2025-07-31/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.landing.siakng_tlu_status_irs (
  kd_status BIGINT
  nm_status_ind VARCHAR
  nm_status_ing VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/landing/siakng/tlu_status_irs/2025-08-01/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.landing.siakng_tlu_unit_organisasi (
  kd_org VARCHAR
  nama_org_ind VARCHAR
  nama_org_ing VARCHAR
  no_organisasi VARCHAR
  alamat VARCHAR
  pemimpin_organisasi VARCHAR
  kd_lokasi DOUBLE
  telp VARCHAR
  fax VARCHAR
  email VARCHAR
  contact VARCHAR
  kd_jenjang VARCHAR
  kd_umpt VARCHAR
  kd_prg_pendidikan VARCHAR
  kd_jenis_org BIGINT
  kd_parent_org VARCHAR
  kd_dikti VARCHAR
  kd_jenis_sistem BIGINT
  nama_org_singkat VARCHAR
  mapping_ruangan VARCHAR
  active VARCHAR
  decree_no VARCHAR
  decree_until TIMESTAMP
  approved VARCHAR
  kd_surat VARCHAR
  kd_peringkat VARCHAR
  sk_peringkat VARCHAR
  exp_peringkat TIMESTAMP
  pmn_grc VARCHAR
  pmn_trc VARCHAR
  nilai_peringkat DOUBLE
  no_sertifikat VARCHAR
  tgl_sk_peringkat TIMESTAMP
  masa_studi DOUBLE
  normal_terms DOUBLE
  id_prodi_dikti VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/landing/siakng/tlu_unit_organisasi/2025-07-24/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.landing.siakng_tlu_unit_organisasi (
  kd_org VARCHAR
  nama_org_ind VARCHAR
  nama_org_ing VARCHAR
  no_organisasi VARCHAR
  alamat VARCHAR
  pemimpin_organisasi VARCHAR
  kd_lokasi DOUBLE
  telp VARCHAR
  fax VARCHAR
  email VARCHAR
  contact VARCHAR
  kd_jenjang VARCHAR
  kd_umpt VARCHAR
  kd_prg_pendidikan VARCHAR
  kd_jenis_org BIGINT
  kd_parent_org VARCHAR
  kd_dikti VARCHAR
  kd_jenis_sistem BIGINT
  nama_org_singkat VARCHAR
  mapping_ruangan VARCHAR
  active VARCHAR
  decree_no VARCHAR
  decree_until TIMESTAMP
  approved VARCHAR
  kd_surat VARCHAR
  kd_peringkat VARCHAR
  sk_peringkat VARCHAR
  exp_peringkat TIMESTAMP
  pmn_grc VARCHAR
  pmn_trc VARCHAR
  nilai_peringkat DOUBLE
  no_sertifikat VARCHAR
  tgl_sk_peringkat TIMESTAMP
  masa_studi DOUBLE
  normal_terms DOUBLE
  id_prodi_dikti VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/landing/siakng/tlu_unit_organisasi/2025-07-31/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.landing.siakng_tlu_unit_organisasi (
  kd_org VARCHAR
  nama_org_ind VARCHAR
  nama_org_ing VARCHAR
  no_organisasi VARCHAR
  alamat VARCHAR
  pemimpin_organisasi VARCHAR
  kd_lokasi DOUBLE
  telp VARCHAR
  fax VARCHAR
  email VARCHAR
  contact VARCHAR
  kd_jenjang VARCHAR
  kd_umpt VARCHAR
  kd_prg_pendidikan VARCHAR
  kd_jenis_org BIGINT
  kd_parent_org VARCHAR
  kd_dikti VARCHAR
  kd_jenis_sistem BIGINT
  nama_org_singkat VARCHAR
  mapping_ruangan VARCHAR
  active VARCHAR
  decree_no VARCHAR
  decree_until TIMESTAMP
  approved VARCHAR
  kd_surat VARCHAR
  kd_peringkat VARCHAR
  sk_peringkat VARCHAR
  exp_peringkat TIMESTAMP
  pmn_grc VARCHAR
  pmn_trc VARCHAR
  nilai_peringkat DOUBLE
  no_sertifikat VARCHAR
  tgl_sk_peringkat TIMESTAMP
  masa_studi DOUBLE
  normal_terms DOUBLE
  id_prodi_dikti VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/landing/siakng/tlu_unit_organisasi/2025-08-01/'
);

CREATE SCHEMA IF NOT EXISTS dtd_dw_sandbox.raw;

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.edom_edom (
  kd_kls_mk BIGINT
  id_pertanyaan BIGINT
  nip VARCHAR
  nilai BIGINT
  id_edom BIGINT
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/edom/edom/2025-07-31/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.edom_pengajar_kuliah_mahasiswa (
  kd_mhs VARCHAR
  prg_studi VARCHAR
  kd_kls_mk BIGINT
  nip VARCHAR
  flag BIGINT
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/edom/pengajar_kuliah_mahasiswa/2025-08-04/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.edom_tlu_edom (
  id_edom BIGINT
  thn VARCHAR
  term VARCHAR
  jenjang VARCHAR
  flag_efom VARCHAR
  flag_mksp VARCHAR
  flag_rik VARCHAR
  flag_elearning VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/edom/tlu_edom/2025-07-31/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.edom_tlu_edom (
  id_edom BIGINT
  thn VARCHAR
  term VARCHAR
  jenjang VARCHAR
  flag_efom VARCHAR
  flag_mksp VARCHAR
  flag_rik VARCHAR
  flag_elearning VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/edom/tlu_edom/2025-08-04/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.edom_tlu_edom (
  id_edom BIGINT
  thn VARCHAR
  term VARCHAR
  jenjang VARCHAR
  flag_efom VARCHAR
  flag_mksp VARCHAR
  flag_rik VARCHAR
  flag_elearning VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/edom/tlu_edom/2025-08-05/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.edom_tlu_grup_pertanyaan (
  id_grup BIGINT
  id_edom BIGINT
  teks VARCHAR
  penilaian VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/edom/tlu_grup_pertanyaan/2025-07-31/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.edom_tlu_grup_pertanyaan (
  id_grup BIGINT
  id_edom BIGINT
  teks VARCHAR
  penilaian VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/edom/tlu_grup_pertanyaan/2025-08-04/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.edom_tlu_grup_pertanyaan (
  id_grup BIGINT
  id_edom BIGINT
  teks VARCHAR
  penilaian VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/edom/tlu_grup_pertanyaan/2025-08-05/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.edom_tlu_pertanyaan (
  id_pertanyaan BIGINT
  id_grup BIGINT
  id_edom BIGINT
  teks VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/edom/tlu_pertanyaan/2025-07-31/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.edom_tlu_pertanyaan (
  id_pertanyaan BIGINT
  id_grup BIGINT
  id_edom BIGINT
  teks VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/edom/tlu_pertanyaan/2025-08-04/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.edom_tlu_pertanyaan (
  id_pertanyaan BIGINT
  id_grup BIGINT
  id_edom BIGINT
  teks VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/edom/tlu_pertanyaan/2025-08-05/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.external_ban-pt_akreditasi (
  perguruan_tinggi VARCHAR
  program_studi VARCHAR
  strata VARCHAR
  wilayah VARCHAR
  no_sk VARCHAR
  tahun_sk VARCHAR
  peringkat VARCHAR
  expired VARCHAR
  note VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/external/ban-pt/akreditasi/2025-09-11/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.external_ban-pt_akreditasi (
  perguruan_tinggi VARCHAR
  program_studi VARCHAR
  strata VARCHAR
  wilayah VARCHAR
  no_sk VARCHAR
  tahun_sk VARCHAR
  peringkat VARCHAR
  expired VARCHAR
  note VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/external/ban-pt/akreditasi/2025-09-12/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.external_upload_Data_Pembagian_Asdos,_Dosen,_&_Mahasiswa_Asdos (
  No VARCHAR
  Nama VARCHAR
  Username Akun GitHub VARCHAR
  Kode Asdos VARCHAR
  ID line VARCHAR
  No WA (Gunakan 08xx) VARCHAR
  Status VARCHAR
  Sudah Enroll VARCHAR
  Sudah diassign VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/external/upload/Data_Pembagian_Asdos,_Dosen,_&_Mahasiswa_Asdos/2025-09-17/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.external_upload_Data_Pembagian_Asdos,_Dosen,_&_Mahasiswa_Dosen (
  No VARCHAR
  Nama Beserta Gelar VARCHAR
  E-Mail VARCHAR
  Mengajar Kelas VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/external/upload/Data_Pembagian_Asdos,_Dosen,_&_Mahasiswa_Dosen/2025-09-17/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.external_upload_Data_Pembagian_Asdos,_Dosen,_&_Mahasiswa_Kelas_A (
  No VARCHAR
  NPM VARCHAR
  Nama  VARCHAR
  No Kelompok VARCHAR
  Nama VARCHAR
  Kode Asdos VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/external/upload/Data_Pembagian_Asdos,_Dosen,_&_Mahasiswa_Kelas_A/2025-09-17/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.external_upload_Data_Pembagian_Asdos,_Dosen,_&_Mahasiswa_Kelas_B (
  No VARCHAR
  NPM VARCHAR
  Nama  VARCHAR
  No Kelompok VARCHAR
  Nama VARCHAR
  Kode Asdos VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/external/upload/Data_Pembagian_Asdos,_Dosen,_&_Mahasiswa_Kelas_B/2025-09-17/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.external_upload_Data_Pembagian_Asdos,_Dosen,_&_Mahasiswa_Kelas_C (
  No VARCHAR
  NPM VARCHAR
  Nama  VARCHAR
  No Kelompok VARCHAR
  Nama VARCHAR
  Kode Asdos VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/external/upload/Data_Pembagian_Asdos,_Dosen,_&_Mahasiswa_Kelas_C/2025-09-17/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.external_upload_Data_Pembagian_Asdos,_Dosen,_&_Mahasiswa_Kelas_D (
  No VARCHAR
  NPM VARCHAR
  Nama  VARCHAR
  No Kelompok VARCHAR
  Nama VARCHAR
  Kode Asdos VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/external/upload/Data_Pembagian_Asdos,_Dosen,_&_Mahasiswa_Kelas_D/2025-09-17/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.external_upload_Data_Pembagian_Asdos,_Dosen,_&_Mahasiswa_Kelas_E (
  No VARCHAR
  NPM VARCHAR
  Nama  VARCHAR
  No Kelompok VARCHAR
  Nama VARCHAR
  Kode Asdos VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/external/upload/Data_Pembagian_Asdos,_Dosen,_&_Mahasiswa_Kelas_E/2025-09-17/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.external_upload_Data_Pembagian_Asdos,_Dosen,_&_Mahasiswa_Kelas_F (
  No VARCHAR
  NPM VARCHAR
  Nama  VARCHAR
  No Kelompok VARCHAR
  Nama VARCHAR
  Kode Asdos VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/external/upload/Data_Pembagian_Asdos,_Dosen,_&_Mahasiswa_Kelas_F/2025-09-17/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.external_upload_rank_aur (
  lembaga VARCHAR
  tahun VARCHAR
  rank VARCHAR
  rank_value VARCHAR
  overall VARCHAR
  overall_value VARCHAR
  citations VARCHAR
  industry_income VARCHAR
  international_outlook VARCHAR
  research VARCHAR
  teaching VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/external/upload/rank_aur/2025-09-17/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.external_upload_rank_impact (
  lembaga VARCHAR
  rank VARCHAR
  rank_value VARCHAR
  overall VARCHAR
  overall_value VARCHAR
  tahun VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/external/upload/rank_impact/2025-09-17/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.external_upload_rank_wur (
  lembaga VARCHAR
  tahun VARCHAR
  rank VARCHAR
  rank_value VARCHAR
  overall VARCHAR
  overall_value VARCHAR
  teacher VARCHAR
  research_environment VARCHAR
  research_quality VARCHAR
  industry VARCHAR
  internasional_look VARCHAR
  no_of_fte_students VARCHAR
  no_of_students_per_staff VARCHAR
  international_students VARCHAR
  female_male_ratio VARCHAR
  interdisciplinary_science_research VARCHAR
  female_male_ratio_value VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/external/upload/rank_wur/2025-09-17/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.siakng_academic_record (
  kd_mhs VARCHAR
  kd_org VARCHAR
  thn BIGINT
  term_ke BIGINT
  ips DOUBLE
  ipk DOUBLE
  ipks DOUBLE
  kd_st_akademis BIGINT
  term BIGINT
  kd_kur VARCHAR
  status_administrasi BIGINT
  skip_tunggakan BIGINT
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/siakng/academic_record/2025-07-31/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.siakng_detail_mahasiswa (
  kd_mhs VARCHAR
  kd_org VARCHAR
  angkatan BIGINT
  jdl_ta_ind VARCHAR
  jdl_ta_ing VARCHAR
  tgl_lulus TIMESTAMP
  no_ijazah VARCHAR
  kd_predikat_lulus VARCHAR
  flag_transkrip BIGINT
  jalur_msk_ui BIGINT
  kd_group_pa DOUBLE
  abstrak_ta_ind VARCHAR
  abstrak_ta_ing VARCHAR
  kd_kur VARCHAR
  no_sk_lulus VARCHAR
  kd_pmn VARCHAR
  date_archive TIMESTAMP
  take_cert TIMESTAMP
  take_tran TIMESTAMP
  thn_ijazah DOUBLE
  no_ijazah_nasional VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/siakng/detail_mahasiswa/2025-08-11/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.siakng_dosen (
  nip VARCHAR
  nama_dosen VARCHAR
  kd_org VARCHAR
  aktif VARCHAR
  skema_id DOUBLE
  nama_skema VARCHAR
  maks_sks DOUBLE
  nm_dosen VARCHAR
  ldap_acc VARCHAR
  nidn VARCHAR
  jabatan VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/siakng/dosen/2025-07-31/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.siakng_dosen (
  nip VARCHAR
  nama_dosen VARCHAR
  kd_org VARCHAR
  aktif VARCHAR
  skema_id DOUBLE
  nama_skema VARCHAR
  maks_sks DOUBLE
  nm_dosen VARCHAR
  ldap_acc VARCHAR
  nidn VARCHAR
  jabatan VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/siakng/dosen/2025-08-03/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.siakng_irs (
  kd_mhs VARCHAR
  thn_ajaran BIGINT
  term BIGINT
  status BIGINT
  timestamp TIMESTAMP
  nilai_huruf VARCHAR
  status_lulus DOUBLE
  kd_kls_mk BIGINT
  flag_mk_luar VARCHAR
  prg_studi VARCHAR
  timestamp_nilai TIMESTAMP
  flag_dropped VARCHAR
  nilai_akhir DOUBLE
  flag_added VARCHAR
  flag_edom VARCHAR
  flag_manual VARCHAR
  id_transfer DOUBLE
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/siakng/irs/2025-07-31/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.siakng_kelas_mata_kuliah (
  kd_kls_mk BIGINT
  term BIGINT
  kd_mk VARCHAR
  kd_kur VARCHAR
  koord_kls_mk VARCHAR
  jml_mhs_terdaftar DOUBLE
  kapasitas_kelas DOUBLE
  jenis_kelas BIGINT
  nm_kls_mk VARCHAR
  thn BIGINT
  status VARCHAR
  show_letter VARCHAR
  flag_transfer BIGINT
  tujuan_kls_mk VARCHAR
  kd_unit_adm VARCHAR
  tujuan_kls_mk_ing VARCHAR
  kd_bhs BIGINT
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/siakng/kelas_mata_kuliah/2025-07-31/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.siakng_kelas_mata_kuliah (
  kd_kls_mk BIGINT
  term BIGINT
  kd_mk VARCHAR
  kd_kur VARCHAR
  koord_kls_mk VARCHAR
  jml_mhs_terdaftar DOUBLE
  kapasitas_kelas DOUBLE
  jenis_kelas BIGINT
  nm_kls_mk VARCHAR
  thn BIGINT
  status VARCHAR
  show_letter VARCHAR
  flag_transfer BIGINT
  tujuan_kls_mk VARCHAR
  kd_unit_adm VARCHAR
  tujuan_kls_mk_ing VARCHAR
  kd_bhs BIGINT
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/siakng/kelas_mata_kuliah/2025-08-03/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.siakng_kurikulum (
  kd_kur VARCHAR
  kd_org VARCHAR
  tahun BIGINT
  deskripsi VARCHAR
  total_sks BIGINT
  maks_masa_studi DOUBLE
  kd_program VARCHAR
  sk_rektor VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/siakng/kurikulum/2025-07-31/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.siakng_kurikulum (
  kd_kur VARCHAR
  kd_org VARCHAR
  tahun BIGINT
  deskripsi VARCHAR
  total_sks BIGINT
  maks_masa_studi DOUBLE
  kd_program VARCHAR
  sk_rektor VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/siakng/kurikulum/2025-08-03/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.siakng_lulusan (
  kd_mhs VARCHAR
  kd_org VARCHAR
  nm_mhs VARCHAR
  angkatan BIGINT
  tgl_lahir TIMESTAMP
  tmpt_lahir VARCHAR
  jns_kelamin VARCHAR
  tgl_lulus TIMESTAMP
  sk_lulus VARCHAR
  no_ijazah VARCHAR
  predikat VARCHAR
  ipk DOUBLE
  sks BIGINT
  nm_fac_ind VARCHAR
  nm_fac_ing VARCHAR
  nm_org_ind VARCHAR
  nm_org_ing VARCHAR
  nm_prg_ind VARCHAR
  nm_prg_ing VARCHAR
  nm_jenjang_ind VARCHAR
  nm_jenjang_ing VARCHAR
  jdl_ta_ind VARCHAR
  jdl_ta_ing VARCHAR
  ipk_mtr DOUBLE
  sks_mtr BIGINT
  gelar_ind VARCHAR
  gelar_ing VARCHAR
  glr_ind VARCHAR
  glr_ing VARCHAR
  nm_pmn_ind VARCHAR
  nm_pmn_ing VARCHAR
  jns_gelar VARCHAR
  rector_label VARCHAR
  rector_name VARCHAR
  dean_label VARCHAR
  dean_name VARCHAR
  sign_date TIMESTAMP
  no_ijazah_nasional VARCHAR
  nik VARCHAR
  kd_afwn VARCHAR
  sk_peringkat VARCHAR
  sk_peringkat_ui VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/siakng/lulusan/2025-07-31/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.siakng_mata_kuliah (
  kd_mk VARCHAR
  kd_kur VARCHAR
  nm_mk VARCHAR
  nm_singkat_mk_ind VARCHAR
  nm_singkat_mk_ing VARCHAR
  jml_sks BIGINT
  kd_jenis_mk DOUBLE
  silabus VARCHAR
  lingkup BIGINT
  ipk_min DOUBLE
  untuk_term BIGINT
  flag_mk_spesial BIGINT
  sks_min DOUBLE
  nm_mk_ing VARCHAR
  equality_list VARCHAR
  kd_sk VARCHAR
  class_type BIGINT
  silabus_ing VARCHAR
  flag_mk_spesial_final VARCHAR
  kd_evalmk DOUBLE
  equality_list2 VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/siakng/mata_kuliah/2025-07-31/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.siakng_mata_kuliah (
  kd_mk VARCHAR
  kd_kur VARCHAR
  nm_mk VARCHAR
  nm_singkat_mk_ind VARCHAR
  nm_singkat_mk_ing VARCHAR
  jml_sks BIGINT
  kd_jenis_mk DOUBLE
  silabus VARCHAR
  lingkup BIGINT
  ipk_min DOUBLE
  untuk_term BIGINT
  flag_mk_spesial BIGINT
  sks_min DOUBLE
  nm_mk_ing VARCHAR
  equality_list VARCHAR
  kd_sk VARCHAR
  class_type BIGINT
  silabus_ing VARCHAR
  flag_mk_spesial_final VARCHAR
  kd_evalmk DOUBLE
  equality_list2 VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/siakng/mata_kuliah/2025-08-03/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.siakng_organisasi (
  kd_org VARCHAR
  nama_org_ind VARCHAR
  nm_jenjang VARCHAR
  kd_umpt VARCHAR
  nm_program_ind VARCHAR
  jns_unit_org VARCHAR
  kd_parent_org VARCHAR
  nm_sistem VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/siakng/organisasi/2025-07-31/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.siakng_organisasi (
  kd_org VARCHAR
  nama_org_ind VARCHAR
  nm_jenjang VARCHAR
  kd_umpt VARCHAR
  nm_program_ind VARCHAR
  jns_unit_org VARCHAR
  kd_parent_org VARCHAR
  nm_sistem VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/siakng/organisasi/2025-08-03/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.siakng_prodi (
  kd_org VARCHAR
  nama_org_ind VARCHAR
  nama_org_ing VARCHAR
  no_organisasi VARCHAR
  alamat VARCHAR
  pemimpin_organisasi VARCHAR
  kd_lokasi DOUBLE
  telp VARCHAR
  fax VARCHAR
  email VARCHAR
  contact VARCHAR
  kd_jenjang VARCHAR
  kd_umpt VARCHAR
  kd_prg_pendidikan VARCHAR
  kd_jenis_org BIGINT
  kd_parent_org VARCHAR
  kd_dikti VARCHAR
  kd_jenis_sistem BIGINT
  nama_org_singkat VARCHAR
  mapping_ruangan VARCHAR
  active VARCHAR
  decree_no VARCHAR
  decree_until TIMESTAMP
  approved VARCHAR
  kd_surat VARCHAR
  kd_peringkat VARCHAR
  sk_peringkat VARCHAR
  exp_peringkat TIMESTAMP
  pmn_grc VARCHAR
  pmn_trc VARCHAR
  nilai_peringkat DOUBLE
  no_sertifikat VARCHAR
  tgl_sk_peringkat TIMESTAMP
  masa_studi DOUBLE
  normal_terms DOUBLE
  id_prodi_dikti VARCHAR
  pp_kd_program VARCHAR
  pp_nm_program_ind VARCHAR
  pp_nm_program_ing VARCHAR
  pp_kd_dikti VARCHAR
  pp_masa_studi DOUBLE
  pp_kd_jenjang VARCHAR
  pp_normal_terms DOUBLE
  pp_urutan BIGINT
  pp_f_obm BIGINT
  jn_kd_jenjang VARCHAR
  jn_nm_jenjang VARCHAR
  jn_nm_jenjang_ing VARCHAR
  jn_jns_gelar VARCHAR
  jn_up_ipk_cumlaude DOUBLE
  jn_urutan BIGINT
  jn_id_pddikti VARCHAR
  jn_flag_nina BIGINT
  jn_normal_terms BIGINT
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/siakng/prodi/2025-07-31/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.siakng_prodi (
  kd_org VARCHAR
  nama_org_ind VARCHAR
  nama_org_ing VARCHAR
  no_organisasi VARCHAR
  alamat VARCHAR
  pemimpin_organisasi VARCHAR
  kd_lokasi DOUBLE
  telp VARCHAR
  fax VARCHAR
  email VARCHAR
  contact VARCHAR
  kd_jenjang VARCHAR
  kd_umpt VARCHAR
  kd_prg_pendidikan VARCHAR
  kd_jenis_org BIGINT
  kd_parent_org VARCHAR
  kd_dikti VARCHAR
  kd_jenis_sistem BIGINT
  nama_org_singkat VARCHAR
  mapping_ruangan VARCHAR
  active VARCHAR
  decree_no VARCHAR
  decree_until TIMESTAMP
  approved VARCHAR
  kd_surat VARCHAR
  kd_peringkat VARCHAR
  sk_peringkat VARCHAR
  exp_peringkat TIMESTAMP
  pmn_grc VARCHAR
  pmn_trc VARCHAR
  nilai_peringkat DOUBLE
  no_sertifikat VARCHAR
  tgl_sk_peringkat TIMESTAMP
  masa_studi DOUBLE
  normal_terms DOUBLE
  id_prodi_dikti VARCHAR
  pp_kd_program VARCHAR
  pp_nm_program_ind VARCHAR
  pp_nm_program_ing VARCHAR
  pp_kd_dikti VARCHAR
  pp_masa_studi DOUBLE
  pp_kd_jenjang VARCHAR
  pp_normal_terms DOUBLE
  pp_urutan BIGINT
  pp_f_obm BIGINT
  jn_kd_jenjang VARCHAR
  jn_nm_jenjang VARCHAR
  jn_nm_jenjang_ing VARCHAR
  jn_jns_gelar VARCHAR
  jn_up_ipk_cumlaude DOUBLE
  jn_urutan BIGINT
  jn_id_pddikti VARCHAR
  jn_flag_nina BIGINT
  jn_normal_terms BIGINT
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/siakng/prodi/2025-08-03/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.siakng_tlu_jenis_kelas (
  kd_jenis_kelas BIGINT
  nm_jenis_kelas VARCHAR
  aktif VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/siakng/tlu_jenis_kelas/2025-07-31/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.siakng_tlu_jenis_kelas (
  kd_jenis_kelas BIGINT
  nm_jenis_kelas VARCHAR
  aktif VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/siakng/tlu_jenis_kelas/2025-08-03/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.siakng_tlu_mutu_nilai (
  nilai_mk VARCHAR
  mutu_nilai DOUBLE
  complete VARCHAR
  occurence VARCHAR
  count_ip VARCHAR
  status_lulus BIGINT
  range_score VARCHAR
  default_range_min DOUBLE
  default_range_max DOUBLE
  count_credits VARCHAR
  count_pdpt VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/siakng/tlu_mutu_nilai/2025-07-31/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.siakng_tlu_mutu_nilai (
  nilai_mk VARCHAR
  mutu_nilai DOUBLE
  complete VARCHAR
  occurence VARCHAR
  count_ip VARCHAR
  status_lulus BIGINT
  range_score VARCHAR
  default_range_min DOUBLE
  default_range_max DOUBLE
  count_credits VARCHAR
  count_pdpt VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/siakng/tlu_mutu_nilai/2025-08-03/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.siakng_tlu_status_irs (
  kd_status BIGINT
  nm_status_ind VARCHAR
  nm_status_ing VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/siakng/tlu_status_irs/2025-07-31/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.siakng_tlu_status_irs (
  kd_status BIGINT
  nm_status_ind VARCHAR
  nm_status_ing VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/siakng/tlu_status_irs/2025-08-03/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.siakng_tlu_unit_organisasi (
  kd_org VARCHAR
  nama_org_ind VARCHAR
  nama_org_ing VARCHAR
  no_organisasi VARCHAR
  alamat VARCHAR
  pemimpin_organisasi VARCHAR
  kd_lokasi DOUBLE
  telp VARCHAR
  fax VARCHAR
  email VARCHAR
  contact VARCHAR
  kd_jenjang VARCHAR
  kd_umpt VARCHAR
  kd_prg_pendidikan VARCHAR
  kd_jenis_org BIGINT
  kd_parent_org VARCHAR
  kd_dikti VARCHAR
  kd_jenis_sistem BIGINT
  nama_org_singkat VARCHAR
  mapping_ruangan VARCHAR
  active VARCHAR
  decree_no VARCHAR
  decree_until TIMESTAMP
  approved VARCHAR
  kd_surat VARCHAR
  kd_peringkat VARCHAR
  sk_peringkat VARCHAR
  exp_peringkat TIMESTAMP
  pmn_grc VARCHAR
  pmn_trc VARCHAR
  nilai_peringkat DOUBLE
  no_sertifikat VARCHAR
  tgl_sk_peringkat TIMESTAMP
  masa_studi DOUBLE
  normal_terms DOUBLE
  id_prodi_dikti VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/siakng/tlu_unit_organisasi/2025-07-31/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.raw.siakng_tlu_unit_organisasi (
  kd_org VARCHAR
  nama_org_ind VARCHAR
  nama_org_ing VARCHAR
  no_organisasi VARCHAR
  alamat VARCHAR
  pemimpin_organisasi VARCHAR
  kd_lokasi DOUBLE
  telp VARCHAR
  fax VARCHAR
  email VARCHAR
  contact VARCHAR
  kd_jenjang VARCHAR
  kd_umpt VARCHAR
  kd_prg_pendidikan VARCHAR
  kd_jenis_org BIGINT
  kd_parent_org VARCHAR
  kd_dikti VARCHAR
  kd_jenis_sistem BIGINT
  nama_org_singkat VARCHAR
  mapping_ruangan VARCHAR
  active VARCHAR
  decree_no VARCHAR
  decree_until TIMESTAMP
  approved VARCHAR
  kd_surat VARCHAR
  kd_peringkat VARCHAR
  sk_peringkat VARCHAR
  exp_peringkat TIMESTAMP
  pmn_grc VARCHAR
  pmn_trc VARCHAR
  nilai_peringkat DOUBLE
  no_sertifikat VARCHAR
  tgl_sk_peringkat TIMESTAMP
  masa_studi DOUBLE
  normal_terms DOUBLE
  id_prodi_dikti VARCHAR
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/raw/siakng/tlu_unit_organisasi/2025-08-03/'
);

CREATE SCHEMA IF NOT EXISTS dtd_dw_sandbox.validated;

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.validated.academic_irs_course_details (
  irs_course_detail_id VARCHAR
  kd_kls_mk VARCHAR
  kode_mk VARCHAR
  nama_mk VARCHAR
  sks BIGINT
  nilai_huruf VARCHAR
  mutu_nilai DOUBLE
  status_mk VARCHAR
  status_lulus BOOLEAN
  pengambilan_ke BIGINT
  kode_mahasiswa VARCHAR
  tahun_ajaran BIGINT
  semester BIGINT
  created_date TIMESTAMP
  updated_date TIMESTAMP
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/validated/academic/irs_course_details/2025-07-28/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.validated.academic_irs_course_details (
  irs_course_detail_id VARCHAR
  kd_kls_mk VARCHAR
  kode_mk VARCHAR
  nama_mk VARCHAR
  sks BIGINT
  nilai_huruf VARCHAR
  mutu_nilai DOUBLE
  status_mk VARCHAR
  status_lulus BOOLEAN
  pengambilan_ke BIGINT
  kode_mahasiswa VARCHAR
  tahun_ajaran BIGINT
  semester BIGINT
  created_date TIMESTAMP
  updated_date TIMESTAMP
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/validated/academic/irs_course_details/2025-07-29/'
);

CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.validated.academic_irs_summary (
  irs_summary_id VARCHAR
  kode_mahasiswa VARCHAR
  tahun_ajaran BIGINT
  semester BIGINT
  semester_mahasiswa BIGINT
  total_mk_diambil BIGINT
  total_mk_lulus BIGINT
  total_sks_diambil BIGINT
  total_sks_lulus BIGINT
  total_mutu_sks DOUBLE
  ips DOUBLE
  sks_kumulatif BIGINT
  mutu_sks_kumulatif DOUBLE
  ipk DOUBLE
  mk_first_attempt BIGINT
  mk_retake BIGINT
  mk_grade_improvement BIGINT
  potensi_do BOOLEAN
  eligible_graduation BOOLEAN
  hash_fingerprint BIGINT
  created_date TIMESTAMP
  updated_date TIMESTAMP
) WITH (
  format = 'PARQUET',
  external_location = 's3a://dtd-dw-sandbox/validated/academic/irs_summary/2025-07-28/'
);

