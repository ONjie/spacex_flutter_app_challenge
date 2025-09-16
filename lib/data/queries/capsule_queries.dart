// Capsule queries for SpaceX API
// Fetch data about SpaceX capsules

//Get All Cpasules
const String getAllCapsules = r'''
  query getCapsules {
    capsules {
      id
      reuse_count
      status
      type
    }
  }
''';

//Gets Capsule by its id
const String getCapsuleById = r'''
  query getCapsule($id: ID!) {
    capsule(id: $id){
      id
      reuse_count
      status
      type
    }
  }
''';
