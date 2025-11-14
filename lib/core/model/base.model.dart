class CategoryModel {
  final String id;
  final String title;
  final String iconUrl; // network icon or placeholder
  CategoryModel({required this.id, required this.title, required this.iconUrl});
}

class MedicalCenter {
  final String id;
  final String name;
  final String imageUrl;
  MedicalCenter({required this.id, required this.name, required this.imageUrl});
}

class Doctor {
  final String id;
  final String name;
  final String specialty;
  final String imageUrl;
  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.imageUrl,
  });
}

// ---------------------- Mock Repository (simulates API) ----------------------
class MockRepository {
  Future<List<CategoryModel>> fetchCategories() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      CategoryModel(
        id: '1',
        title: 'Dentistry',
        iconUrl: 'https://img.icons8.com/fluency/48/000000/tooth.png',
      ),
      CategoryModel(
        id: '2',
        title: 'Cardiology',
        iconUrl: 'https://img.icons8.com/fluency/48/000000/heartbeat.png',
      ),
      CategoryModel(
        id: '3',
        title: 'Pulmonology',
        iconUrl: 'https://img.icons8.com/fluency/48/000000/lungs.png',
      ),
      CategoryModel(
        id: '4',
        title: 'General',
        iconUrl: 'https://img.icons8.com/fluency/48/000000/stethoscope.png',
      ),
      CategoryModel(
        id: '5',
        title: 'Neurology',
        iconUrl: 'https://img.icons8.com/fluency/48/000000/brain.png',
      ),
      CategoryModel(
        id: '6',
        title: 'Gastroenterology',
        iconUrl: 'https://img.icons8.com/fluency/48/000000/stomach.png',
      ),
      CategoryModel(
        id: '7',
        title: 'Laboratory',
        iconUrl: 'https://img.icons8.com/fluency/48/000000/test-tube.png',
      ),
      CategoryModel(
        id: '8',
        title: 'Vaccination',
        iconUrl: 'https://img.icons8.com/fluency/48/000000/syringe.png',
      ),
    ];
  }

  Future<List<MedicalCenter>> fetchCenters() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return [
      MedicalCenter(
        id: 'c1',
        name: 'Sunrise Health Clinic',
        imageUrl:
            'https://images.unsplash.com/photo-1586773860416-1f7c8a1b1b7a?auto=format&fit=crop&w=800&q=60',
      ),
      MedicalCenter(
        id: 'c2',
        name: 'Golden Cardiology',
        imageUrl:
            'https://images.unsplash.com/photo-1587502536263-1a0b7d9b1f18?auto=format&fit=crop&w=800&q=60',
      ),
      MedicalCenter(
        id: 'c3',
        name: 'City Diagnostics',
        imageUrl:
            'https://images.unsplash.com/photo-1580281657528-3f8f0c6a2a8e?auto=format&fit=crop&w=800&q=60',
      ),
    ];
  }

  Future<List<Doctor>> fetchDoctors() async {
    await Future.delayed(const Duration(milliseconds: 700));
    return [
      Doctor(
        id: 'd1',
        name: 'Dr. Sarah Lee',
        specialty: 'Cardiologist',
        imageUrl:
            'https://images.unsplash.com/photo-1580281657528-3f8f0c6a2a8e?auto=format&fit=crop&w=500&q=60',
      ),
      Doctor(
        id: 'd2',
        name: 'Dr. Ahmed Noor',
        specialty: 'Dentist',
        imageUrl:
            'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=500&q=60',
      ),
      Doctor(
        id: 'd3',
        name: 'Dr. Lina Jacobs',
        specialty: 'Pulmonologist',
        imageUrl:
            'https://images.unsplash.com/photo-1607746882042-944635dfe10e?auto=format&fit=crop&w=500&q=60',
      ),
    ];
  }
}
