// Landpad queries for SpaceX API
// Fetch data about SpaceX landpads

// Get all Landpads
const String getLandpadsQuery = '''
 query getLandpads {
  landpads {
   status
   details
   full_name
   id
   }
 }
''';

// Gets Landpad by its id
const getLandpadByIdQuery = '''
 query getLandpadById(\$id: ID!){
  landpad(id: \$id){
   status
   details
   full_name
   id
  }
 }
''';
