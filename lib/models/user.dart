import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// User Model for both Customers and Barbers
class User extends Equatable {
  final String uid;
  final String email;
  final String name;
  final String? phone;
  final String userType; // 'customer', 'barber', 'admin'
  final List<String> favoriteBarbers;
  final DateTime createdAt;
  final DateTime lastLogin;
  final String? photoUrl;
  final String? city; // City/Location for barber filtering
  final String? state; // State for location-based discovery
  final double? latitude; // GPS coordinates for nearby barbers
  final double? longitude;

  // Barber-specific fields
  final String? shopId; // Shop/Salon ID this barber belongs to
  final String? referralCode; // Referral code (if applicable)
  final String? barberPhotoUrl; // Barber's profile photo
  final int? yearsOfExperience; // Professional experience
  final List<String>? specialties; // Services: ['Haircut', 'Beard Trim', ...]
  final String? bio; // Professional biography
  final double? rating; // Barber's rating
  final int? reviewCount; // Number of reviews
  
  // Address breakdown fields (for barber registration)
  final String? country; // Country
  final String? district; // District
  final String? block; // Block
  final String? village; // Village/Town
  final String? street; // Street address
  final String? nearbyLocation; // Nearby location/landmark

  const User({
    required this.uid,
    required this.email,
    required this.name,
    this.phone,
    required this.userType,
    this.favoriteBarbers = const [],
    required this.createdAt,
    required this.lastLogin,
    this.photoUrl,
    this.city,
    this.state,
    this.latitude,
    this.longitude,
    this.shopId,
    this.referralCode,
    this.barberPhotoUrl,
    this.yearsOfExperience,
    this.specialties,
    this.bio,
    this.rating,
    this.reviewCount,
    this.country,
    this.district,
    this.block,
    this.village,
    this.street,
    this.nearbyLocation,
  });

  /// Getter for displayName (alias for name)
  String get displayName => name;

  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      uid: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      phone: data['phone'],
      userType: data['userType'] ?? 'customer',
      favoriteBarbers: List<String>.from(data['favoriteBarbers'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastLogin: (data['lastLogin'] as Timestamp).toDate(),
      photoUrl: data['photoUrl'],
      city: data['city'],
      state: data['state'],
      latitude: data['latitude'] is num
          ? (data['latitude'] as num).toDouble()
          : null,
      longitude: data['longitude'] is num
          ? (data['longitude'] as num).toDouble()
          : null,
      shopId: data['shopId'],
      referralCode: data['referralCode'],
      barberPhotoUrl: data['barberPhotoUrl'],
      yearsOfExperience: data['yearsOfExperience'],
      specialties: List<String>.from(data['specialties'] ?? []),
      bio: data['bio'],
      rating: data['rating'] is num ? (data['rating'] as num).toDouble() : null,
      reviewCount: data['reviewCount'],
      country: data['country'],
      district: data['district'],
      block: data['block'],
      village: data['village'],
      street: data['street'],
      nearbyLocation: data['nearbyLocation'],
    );
  }

  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> data = {
      'email': email,
      'name': name,
      'userType': userType,
      'favoriteBarbers': favoriteBarbers,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLogin': Timestamp.fromDate(lastLogin),
    };

    // Only include optional fields when they are non-null so we do not
    // overwrite existing values with nulls when calling set(..., merge: true).
    if (phone != null) data['phone'] = phone;
    if (photoUrl != null) data['photoUrl'] = photoUrl;
    if (city != null) data['city'] = city;
    if (state != null) data['state'] = state;
    if (latitude != null) data['latitude'] = latitude;
    if (longitude != null) data['longitude'] = longitude;
    if (shopId != null) data['shopId'] = shopId;
    if (referralCode != null) data['referralCode'] = referralCode;
    if (barberPhotoUrl != null) data['barberPhotoUrl'] = barberPhotoUrl;
    if (yearsOfExperience != null) {
      data['yearsOfExperience'] = yearsOfExperience;
    }
    if (specialties != null && specialties!.isNotEmpty) {
      data['specialties'] = specialties;
    }
    if (bio != null) data['bio'] = bio;
    if (rating != null) data['rating'] = rating;
    if (reviewCount != null) data['reviewCount'] = reviewCount;
    if (country != null) data['country'] = country;
    if (district != null) data['district'] = district;
    if (block != null) data['block'] = block;
    if (village != null) data['village'] = village;
    if (street != null) data['street'] = street;
    if (nearbyLocation != null) data['nearbyLocation'] = nearbyLocation;

    return data;
  }

  User copyWith({
    String? uid,
    String? email,
    String? name,
    String? phone,
    String? userType,
    List<String>? favoriteBarbers,
    DateTime? createdAt,
    DateTime? lastLogin,
    String? photoUrl,
    String? city,
    String? state,
    double? latitude,
    double? longitude,
    String? shopId,
    String? referralCode,
    String? barberPhotoUrl,
    int? yearsOfExperience,
    List<String>? specialties,
    String? bio,
    double? rating,
    int? reviewCount,
    String? country,
    String? district,
    String? block,
    String? village,
    String? street,
    String? nearbyLocation,
  }) {
    return User(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      userType: userType ?? this.userType,
      favoriteBarbers: favoriteBarbers ?? this.favoriteBarbers,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      photoUrl: photoUrl ?? this.photoUrl,
      city: city ?? this.city,
      state: state ?? this.state,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      shopId: shopId ?? this.shopId,
      referralCode: referralCode ?? this.referralCode,
      barberPhotoUrl: barberPhotoUrl ?? this.barberPhotoUrl,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      specialties: specialties ?? this.specialties,
      bio: bio ?? this.bio,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      country: country ?? this.country,
      district: district ?? this.district,
      block: block ?? this.block,
      village: village ?? this.village,
      street: street ?? this.street,
      nearbyLocation: nearbyLocation ?? this.nearbyLocation,
    );
  }

  @override
  List<Object?> get props => [
    uid,
    email,
    name,
    phone,
    userType,
    favoriteBarbers,
    createdAt,
    lastLogin,
    photoUrl,
    city,
    state,
    latitude,
    longitude,
    shopId,
    referralCode,
    barberPhotoUrl,
    yearsOfExperience,
    specialties,
    bio,
    rating,
    reviewCount,
  ];
}
