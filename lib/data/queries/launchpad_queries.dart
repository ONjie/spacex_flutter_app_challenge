// Launchpad queries for SpaceX API
// Fetch data about SpaceX launchpads

const String getLaunchpadsQuery = '''
 query getLaunchpads {
  launchpads {
    details
    id
    name
    status
   }
 }
''';

const getLaunchpadByIdQuery = '''
 query getLaunchpadById(\$id: ID!){
  launchpad(id: \$id){
    details
    id
    name
    status
  }
 }
''';
