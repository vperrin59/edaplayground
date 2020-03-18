module event_race ();

  event e, go;

  // There is a race between always 1 and always 2 block.
  // If always 1 executes before always 2 -> test will finish at 5
  // If always 2 executes before always 1 -> test will finish at 10

  // In order to avoid this race you can use non blocking event triggering (->>)
  // instead of blocking event trigger (->)

  // Another way to avoid the race condition is on the event catch (persistent trigger).
  // Using wait(ev.triggered) will allow an event to persist throughout the time step in which the event is triggered

  always @(go)
  begin
    $display($time,,"Always 1 - triggering e");
    // Blocking event trigger
    ->e;
    // Non blocking event trigger
    // ->>e;
  end

  always @(go)
  begin
    $display($time,,"Always 2 - about to wait on e");
    @(e) $display($time,,"Always 2 - wakeup on e");
    // Persistent trigger
    // wait(e.triggered) $display($time,,"Always 2 - wakeup on e");
    $finish;
  end

  always #5 ->go;

endmodule