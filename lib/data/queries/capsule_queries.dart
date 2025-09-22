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

//Get Capsules by pagination
const String getCapsulesByPaginationQuery = '''
query getCapsulesByPagination(\$offset: Int, \$limit: Int){
    capsules(offset: \$offset, limit: \$limit){
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
