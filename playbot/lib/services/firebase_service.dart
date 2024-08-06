abstract class FirebaseService {
  Future<bool> createRoom();

  Future<bool> joinRoom(String roomID);
}

class FirebaseServiceImpl extends FirebaseService {
  @override
  Future<bool> createRoom() async {
    try {
      return true;
    } catch (e){
      return false;
    }
  }

  @override
  Future<bool> joinRoom(String roomID) async {
    try {
      return true;
    } catch (e){
      return false;
    }
  }
}