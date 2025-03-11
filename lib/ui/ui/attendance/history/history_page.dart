part of '../../../pages.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final dataService = DataServiceHistoryAttendance();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "History",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: dataService.getAttendanceStream(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if(snapshot.hasError){
            return Center(
              child: Text("Gagal mengambil data",style: GoogleFonts.poppins(fontSize: 20,fontWeight: FontWeight.w500),),
            );
          }
          if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
            return Center(
              child: Text("belum ada data",style: GoogleFonts.poppins(fontSize: 20,fontWeight: FontWeight.w500),),
            );
          }
          final data = snapshot.data!.docs;
          return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context,index){
                return AttendanceCardWidget(
                  data : data[index].data() as Map<String,dynamic>,
                  attendanceId : data[index].id,
                );
              },
          );
        },
      )
    );
  }
}

class DataServiceHistoryAttendance {
  final auth = FirebaseAuth.instance;

  //get id attendance
  CollectionReference getUserAttendance() {
    final String userId = auth.currentUser!.uid;
    if (userId == null) {
      throw Exception("Users is not logged in");
    }
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('attendance');
  }
  
  //get data attendance users
  Stream<QuerySnapshot> getAttendanceStream(){
    return getUserAttendance().orderBy('createdAt',descending: true).snapshots();
  }


}
