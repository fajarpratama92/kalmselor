import 'dart:convert';

Map<String, dynamic> COUN_EXPERIENCE = {
  "EXPERIENCE_TITLE": "Pendidikan &\nPengalaman Kerja",
  "EXPERIENCE_CONTACT_1": "Hubungi Admin",
  "EXPERIENCE_CONTACT_2": "untuk memperbaharui data",
  "DEGREE1": "Gelar Pendidikan S1",
  "NAME1": "Universitas",
  "MAJOR1": "Jurusan",
  "DEGREE2": "Gelar Pendidikan S2",
  "NAME2": "Universitas",
  "MAJOR2": "Jurusan",
  "DEGREE3": "Gelar Pendidikan S3",
  "NAME3": "Universitas",
  "MAJOR3": "Jurusan",
  "NUMBER": "Nomor",
  "VALID_UNTIL": "Berlaku Sampai",
  "SKCK": "SKCK",
  "SKCKDATE": "SKCK Berlaku Hingga",
  "SIP": "SIP",
  "SIPDATE": "SIP Berlaku Hingga",
  "EXPERIENCE": "Pengalaman menjadi konselor",
  "JOB": "Pekerjaan saat ini",
  "CERTIFICATES": "Sertifikat (Jika ada)",
  "ORGANIZATION": "Organisasi",
};

Map<String, Map<String, String>> TRANSLATIONDATA = {
  'en': {
    'welcome': 'Welcome',
    "photo": "Photo",
    "first_name": "First Name",
    "last_name": "Last Name",
    "id_number": "Number Id",
    "npwp_number": "NPWP Number",
    "gender": "Gender",
    "religion": "Religion",
    "email": "Email",
    "dob": "Date Of Birth",
    "phone": "Phone",
    "address": "Address",
    "country": "Country",
    "state": "State",
    "city": "City",
    "marital_status": "Marital Status",
    "amount_of_children": "Amount of Children",
    "about_me": "About Me",
    'first_name_reg': 'First Name',
    'last_name_reg': 'Last Name',
    'api_language': 'en',
    'skip': 'Skip',
    'sent': 'Sent',
    'sign_your_code': 'enter codes to continue',
    'we_have_sent_code': "We have sent code to",
    'verify_code': 'VERIFICATION CODE',
    'start': 'Start',
    'unknow_error': 'ooppss!! something when wrong',
    'please_wait': 'Please Wait',
    'change_preference': 'Change Preference',
    'buy_package': 'Buy Package',
    'choose_language': 'Choose Language',
    'logout': 'Logout',
    'about_kalm': 'About Kalm',
    'profile': 'Profile',
    'back': 'Back',
    'tutorial': 'Tutorial',
    'privacy_policy': 'Privacy Policy',
    'terms_and_conditions': 'Terms and Conditions',
    'contack_us': 'Contack Us',
    'support_us': 'Support Us',
    'succes': 'Success',
    'password': 'Password',
    'submit': 'Submit',
    'invalid_character': 'invalid character',
    'password_validator': 'at least 6 characters',
    're_password_validator': 'Password doesn\'t match',
    'login': 'Login',
    'register': 'Register',
    'forgot_password': 'Forgot Password',
    're_password': 'Confirm Your Password',
    'email_validator': 'Make sure your email is not empty',
    'next': 'Next',
    'subscription': "SUBSCRIPTION",
    'total_amount': 'Prices ',
    'pending_payment':
        'You still have a payment that hasn\'t been completed.\nContinue Paying',
    'content': 'CONTENT',
    'counseling': 'COUNSELING',
    'input_promo': 'Promo Code',
    'contack_admin': 'Contack Admin',
    'discount': 'You get discount ',
    'acc_subscription': 'Subscribe to this package',
    'billing_information': 'Billing Information',
    'my_packages': 'My Packages',
    'payment_not_complete': 'Completed Your Payment!',
    'confirm': 'Confirm',
    'package_type': 'PACKAGE TYPES',
    'accept': 'Accept',
    'reject': 'Reject',
    'to_questioner':
        'Please wait \nYou will be directed to the Questioner Page',
    'change_language': 'Change Language (Beta)',
    'account': 'Account',
    'save': 'Save',
    'validate_13yr':
        'I am 13 years old above and\nwant to use this application',
    'dob_reject': 'You are not old enough to use this application',
    'change_password': 'Change Password',
    'match_by_uniq_code': 'You will be linked with Counselor',
    'match_by_system':
        'A suitable Counselor\nwill serve you immediately \nwithin 1x24 hours',
    'null_package':
        'Sorry, the subscription has run out.\nPlease buy a subscription package\nto use the chat feature',
    'clear_pin': "Are You sure delete your pin code?",
    'waiting_payment': 'Please wait. You still have a payment in progress',
    'are_you_sure': 'Are you sure?',
    'attention': 'Attention',
    'additional_credential': 'Additional Credentials',
    'experience': 'Experience',
    'kalm_approval_client': 'kalm Approval - Client',
    'counselor_profile': 'Counselor Profile',
    'write_message': 'Write...',
    'counselor_experience': 'Counselor Experience',
    'matching_questionnaire': 'matching questionnaire',
    'male': 'Male',
    'resend_code': 'Resend code',
    'female': 'Female',
    'make_sure_to_answer': 'Make sure you have selected an answer',
    'make_sure_to_language': 'Make sure you have selected the language',
    'year': 'Year',
    'pin_code_doesnt_match': 'Pin Doesnt match',
    'tranfer_client': 'Tranfer Client Counselor',
    'processing_payment': 'Your Payment is being processed',
    'tnc': 'Do you agree to connect with Counselor ',
    'change_coun_desc': jsonEncode([
      "I feel that my kalm is not\nhandling my needs properly",
      "I am looking for kalm with\ndifferent skills",
      "I want to find a different\nperspective from other kalm",
      "Other"
    ]),
    'coun_change_desc2': jsonEncode([
      "Is there any additional information regarding\nthe reasons you want to replace kalm?\nThis will really help us!",
      "Please select the preference you want\nfor your new kalm after pressing\nthe button below"
    ]),
    'tansfer_client_desc': jsonEncode([
      "I am not suitable with my client in terms of communication",
      "I feel that client complaints are not within my reach",
      "My schedule doesn't match the client's schedule",
      "The client asks to be referred to other Kalmselor",
      "The client made a mistake when ordering Kalmselor",
      "Other"
    ]),
    'profile_translation': jsonEncode([
      'photo',
      'first Name',
      'last Name (optional)',
      'id_number',
      'npwp_number',
      'gender',
      'religion',
      'email',
      'dob',
      'phone (optional)',
      'address',
      'country_id',
      'state_id',
      'city_id',
      'marital_status',
      'amount_of_children',
      'about_me',
    ]),
  },
  'id': {
    'welcome': 'Selamat Datang',
    'api_language': 'id',
    'unknow_error': 'ooppss!! terjadi kesalahan',
    'year': 'Tahun',
    'sent': 'Kirim',
    'start': 'Mulai',
    'back': 'Kembali',
    "photo": "Photo",
    "first_name": "Nama Depan",
    "last_name": "Nama Belakang",
    "id_number": "Nomor Identitas",
    "npwp_number": "Nomor NPWP",
    "gender": "Jenis Kelamin",
    "religion": "Agama",
    "email": "Email",
    "dob": "Tanggal Lahir",
    "phone": "Nomor Hp",
    "address": "Alamat",
    "country": "Negara",
    "state": "Wilayah",
    "city": "Kota",
    "marital_status": "Status Perkawinan",
    "amount_of_children": "Jumlah Anak",
    "about_me": "About Me",
    'we_have_sent_code': "Kami telah mengirimkan kode verifikasi ke",
    'sign_your_code': 'masukan kode untuk melanjutkan',
    'skip': 'Skip',
    'first_name_reg': 'Nama Depan ( Nama Panggilan )',
    'last_name_reg': 'Nama Belakang',
    'to_questioner': 'Mohon tunggu Anda akan diarahkan\nke Halaman Questioner',
    'change_preference': 'Ubah Preferensi',
    'experience': 'Keahlian',
    'counselor_experience': 'Keahlian kalm',
    'matching_questionnaire': 'Kuesioner Keahlian',
    'male': 'Laki-Laki',
    'pin_code_doesnt_match': 'Pin yang Anda masukan tidak sama',
    'female': 'Perempuan',
    'logout': 'Keluar',
    'resend_code': 'Kirim Ulang Kode',
    'make_sure_to_language': 'Pastikan Anda sudah memilih bahasa',
    'make_sure_to_answer': 'Pastikan Anda Telah Memilih Jawaban',
    'confirm': 'Konfirmasi',
    'please_wait': 'Mohon Menunggu',
    'counselor_profile': 'Profil kalm',
    'kalm_approval_client': 'Persetujuan kalm - Klien',
    'additional_credential': 'Kredensial Tambahan',
    'save': 'Simpan',
    'are_you_sure': 'Apakah Anda yakin?',
    'dob_reject':
        'Usia Anda belum mencukupi untuk\ningin menggunakan aplikasi ini',
    'match_by_uniq_code': 'Anda akan dihubungkan dengan kalmselor',
    'match_by_system':
        'Kalmselor yang cocok akan segera melayani\nAnda selambat-lambatnya dalam 1x24 jam',
    'contack_admin': 'Hubungi Admin',
    'choose_language': 'Pilih Bahasa',
    'validate_13yr':
        'Saya berusia 13 tahun keatas \ndan ingin menggunakan aplikasi ini',
    'submit': 'Kirim',
    'change_password': 'Ubah Password',
    'about_kalm': 'Tentang KALM',
    'profile': 'Profil',
    'pending_payment':
        'Anda masih memiliki pembayaran yang belum selesai\nLanjutkan Bayar',
    'billing_information': 'Informasi Tagihan',
    'tutorial': 'Cara Penggunaan',
    'privacy_policy': 'Kebijakan Privasi',
    'terms_and_conditions': 'Syarat dan Ketentuan',
    'contack_us': 'Hubungi Kami',
    'support_us': 'Dukung Kami di',
    'null_package':
        'Maaf paket berlangganan sudah habis.\nSilahkan membeli paket berlangganan\nuntuk menggunakan fitur chat',
    'buy_package': 'Beli Paket',
    'change_language': 'Ubah Bahasa (Beta)',
    'clear_pin': 'Apakah Anda ingin menghapus pin code?',
    'succes': 'Berhasil',
    'chage_password': 'Ganti Password',
    'account': 'Akun',
    'tnc': 'Apakah Anda setuju untuk terhubung dengan kalm ',
    'accept': 'Terima',
    'reject': 'Tolak',
    'package_type': 'JENIS PAKET',
    'waiting_payment':
        'Mohon tunggu Anda masih memiliki pembayaran yang sedang diproses',
    'attention': 'Perhatian',
    'processing_payment': 'Pembayaran sedang diproses',
    'payment_not_complete': 'Pembayaran Belum Selesai',
    'my_packages': 'Paket Saya',
    'write_message': 'Tulis pesan...',
    'acc_subscription': 'Saya ingin berlangganan paket ini',
    'discount': 'Promo potongan Rp.',
    'input_promo': 'Masukan Kode Promo',
    'content': 'KONTEN',
    'counseling': 'KONSELING',
    'verify_code': 'KODE VERIFIKASI',
    'total_amount': 'Total Biaya Rp.',
    'password': 'Password',
    're_password': 'Konfirmasi Password',
    'invalid_character': 'karakter tidak valid',
    'password_validator': 'sedikitnya dibutuhkan 6 karakter',
    're_password_validator': 'Password tidak sama',
    'login': 'Masuk',
    'subscription': 'BERLANGGANAN',
    'register': 'Daftar',
    'forgot_password': 'Lupa Kata Sandi?',
    'email_validator': 'Pastikan Email Anda Telah Diisi',
    'next': 'Selanjutnya',
    'tansfer_client': 'Transfer Klien',
    'change_coun_desc': jsonEncode([
      "Saya merasa kalm saya tidak\nmenangani kebutuhan saya dengan\nbaik",
      "Saya mencari kalm dengan\nkeahlian yang berbeda",
      "Saya ingin mencari perspektif yang\nberbeda dari kalm yang lain",
      "Lainnya"
    ]),
    'coun_change_desc2': jsonEncode([
      "Apakah ada informasi tambahan mengenai\nalasan Anda ingin mengganti kalm? Hal\nini akan sangat membantu kami!",
      "Silahkan memilih preferensi yang Anda\ninginkan untuk kalm baru Anda setelah\nmenekan tombol di bawah"
    ]),
    'tansfer_client_desc': jsonEncode([
      "Saya kurang cocok dengan Klien saya dalam hal komunikasi",
      "Saya merasa keluhan klien bukan termasuk dalam jangkauan saya",
      "Jadwal saya kurang cocok dengan jadwal klien",
      "Klien minta dirujuk ke Kalmselor lainnya",
      "Klien melakukan kesalahan ketika memesan Kalmselor",
      "Lainnya"
    ]),
    'tansfer_client_desc2': jsonEncode([
      "Apakah ada informasi tambahan mengenai\nalasan Anda ingin mengganti Klien? Hal\nini akan sangat membantu kami!",
      "Silahkan memilih preferensi yang Anda\ninginkan untuk Klien baru Anda setelah\nmenekan tombol di bawah"
    ]),
    'profile_translation': jsonEncode([
      'photo',
      'nama depan',
      'nama belakang (optional)',
      'KTP',
      'NPWP',
      'jenis kelamin',
      'agama',
      'email',
      'tanggal lahir',
      'nomor hp (optional)',
      'alamat',
      'kode negara',
      'kode wilayah',
      'kode kota',
      'status pernikahan',
      'jumlah anak',
      'tentang saya',
    ]),
  },
};



class FirebaseWordingResModel {
  String? sessionExpired;
  String? waitingProcess;
  String? uniqcodeRequired;
  String? pleaseWait;
  String? cantCall119;
  String? ageValidation;
  String? addressValidation;
  String? errorSaveStorage;
  String? questionerDataValidation;
  String? copied;
  String? cantOpenShopee;
  String? cantOpenWhatsapp;
  String? cantOpenInstagram;
  String? cantOpenFacebook;
  String? cantOpenYoutube;
  String? cantOpenLink;
  String? somethingWentWrong;
  String? youHaveMoreTry;
  String? shareFromKalm;

  FirebaseWordingResModel(
      {this.sessionExpired,
      this.waitingProcess,
      this.uniqcodeRequired,
      this.pleaseWait,
      this.cantCall119,
      this.ageValidation,
      this.addressValidation,
      this.errorSaveStorage,
      this.questionerDataValidation,
      this.copied,
      this.cantOpenShopee,
      this.cantOpenWhatsapp,
      this.cantOpenInstagram,
      this.cantOpenFacebook,
      this.cantOpenYoutube,
      this.cantOpenLink,
      this.somethingWentWrong,
      this.youHaveMoreTry,
      this.shareFromKalm});

  FirebaseWordingResModel.fromJson(Map<dynamic, dynamic> json) {
    sessionExpired = json['session_expired'];
    waitingProcess = json['waiting_process'];
    uniqcodeRequired = json['uniqcode_required'];
    pleaseWait = json['please_wait'];
    cantCall119 = json['cant_call_119'];
    ageValidation = json['age_validation'];
    addressValidation = json['address_validation'];
    errorSaveStorage = json['error_save_storage'];
    questionerDataValidation = json['questioner_data_validation'];
    copied = json['copied'];
    cantOpenShopee = json['cant_open_shopee'];
    cantOpenWhatsapp = json['cant_open_whatsapp'];
    cantOpenInstagram = json['cant_open_instagram'];
    cantOpenFacebook = json['cant_open_facebook'];
    cantOpenYoutube = json['cant_open_youtube'];
    cantOpenLink = json['cant_open_link'];
    somethingWentWrong = json['something_went_wrong'];
    youHaveMoreTry = json['you_have_more_try'];
    shareFromKalm = json['share_from_kalm'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['session_expired'] = sessionExpired;
    data['waiting_process'] = waitingProcess;
    data['uniqcode_required'] = uniqcodeRequired;
    data['please_wait'] = pleaseWait;
    data['cant_call_119'] = cantCall119;
    data['age_validation'] = ageValidation;
    data['address_validation'] = addressValidation;
    data['error_save_storage'] = errorSaveStorage;
    data['questioner_data_validation'] = questionerDataValidation;
    data['copied'] = copied;
    data['cant_open_shopee'] = cantOpenShopee;
    data['cant_open_whatsapp'] = cantOpenWhatsapp;
    data['cant_open_instagram'] = cantOpenInstagram;
    data['cant_open_facebook'] = cantOpenFacebook;
    data['cant_open_youtube'] = cantOpenYoutube;
    data['cant_open_link'] = cantOpenLink;
    data['something_went_wrong'] = somethingWentWrong;
    data['you_have_more_try'] = youHaveMoreTry;
    data['share_from_kalm'] = shareFromKalm;
    return data;
  }
}

class OrsRefMainModel {
  String? content;
  int? fontSize;
  String? title;

  OrsRefMainModel({this.content, this.fontSize, this.title});

  OrsRefMainModel.fromJson(Map<dynamic, dynamic> json) {
    content = json['content'];
    fontSize = json['fontSize'];
    title = json['title'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    data['content'] = content;
    data['fontSize'] = fontSize;
    data['title'] = title;
    return data;
  }
}

class OrsRefDataModel {
  String? desc;
  int? id;
  String? title;
  double? titleSize;
  double? descSize;

  OrsRefDataModel({
    this.desc,
    this.id,
    this.title,
    this.titleSize,
    this.descSize,
  });

  OrsRefDataModel.fromJson(Map<dynamic, dynamic> json) {
    desc = json['desc'];
    id = json['id'];
    title = json['title'];
    titleSize = json['title_size'].toDouble();
    descSize = json['desc_size'].toDouble();
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    data['desc'] = desc;
    data['id'] = id;
    data['title'] = title;
    data['title_size'] = titleSize;
    data['desc_size'] = descSize;
    return data;
  }
}
