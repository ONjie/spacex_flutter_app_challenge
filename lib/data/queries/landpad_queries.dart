// Landpad queries for SpaceX API
// Fetch data about SpaceX landpads

// Get all Landpads
const String getLandpadsQuery = r'''
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
const getLandpadByIdQuery = r'''
 query getLandpadById($id: ID!){
  landpad(id: $id){
   status
   details
   full_name
   id
  }
 }
''';
