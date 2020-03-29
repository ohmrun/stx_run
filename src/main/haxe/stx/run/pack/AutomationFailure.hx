package stx.run.pack;

enum AutomationFailure<E>{
  E_NoValueFound();
  E_UnknownAutomation(e:Dynamic);
  E_StackOverflow;

  E_Automation(e:Err<E>);
  E_Timeout(?float:Float);

  E_Escape(pos:Pos);
}