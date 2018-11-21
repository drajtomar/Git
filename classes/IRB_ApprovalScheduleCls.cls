public class IRB_ApprovalScheduleCls  implements Schedulable {
   public void execute(SchedulableContext sc) {
      IRB_ApprovalExpNotificationMail b = new IRB_ApprovalExpNotificationMail(); 
      database.executebatch(b);
   }
}