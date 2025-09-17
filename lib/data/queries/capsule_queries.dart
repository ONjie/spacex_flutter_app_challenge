// Capsule queries for SpaceX API
// Fetch data about SpaceX capsules

//Get All Cpasules
const String getCapsulesQuery = '''
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
const String getCapsuleByIdQuery = '''
  query getCapsule(\$id: ID!) {
    capsule(id: \$id){
      id
      reuse_count
      status
      type
    }
  }
''';
