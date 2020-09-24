<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Calculate Number Work Days Between 2 Dates

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

  /**
  * Calculates the number of work days between 2 given times
  *
  * @see get_holidays()
  *
  * @param date $start_date First date
  * @param date $end_date Second date
  * @param bool $workdays_only Whether to count only work days (eg. Mon-Fri)
  * @param bool $skip_holidays Whether to use the get_holidays() function to skip holiday days as well
  * @return int $workday_counter Number of workdays between the 2 dates
  */
  function date_difference($start_date, $end_date, $workdays_only = false, $skip_holidays = false)
  {
      $start_date = strtotime($start_date);
      $end_date = strtotime($end_date);
      $seconds_in_a_day = 86400;
      $sunday_val = "0";
      $saturday_val = "6";
      $workday_counter = 0;
      $holiday_array = array();

      $ptr_year = intval(date("Y", $start_date));
      $holiday_array[$ptr_year] = get_holidays(date("Y", $start_date));

      for($day_val = $start_date; $day_val <= $end_date; $day_val+=$seconds_in_a_day){
          $pointer_day = date("w", $day_val);
          if($workdays_only == true){
              if(($pointer_day != $sunday_val) AND ($pointer_day != $saturday_val)){
                  if($skip_holidays == true){
                      if(intval(date("Y", $day_val))!=$ptr_year){
                          $ptr_year = intval(date("Y", $day_val));
                          $holiday_array[$ptr_year] = get_holidays(date("Y", $day_val));
                      }
                      if(!in_array($day_val, $holiday_array[date("Y", $day_val)])){
                          $workday_counter++;
                      }
                  }else{
                      $workday_counter++;
                  }
              }
          }else{
              if($skip_holidays == true){
                  if(intval(date("Y", $day_val))!=$ptr_year){
                      $ptr_year = intval(date("Y", $day_val));
                      $holiday_array[$ptr_year] = get_holidays(date("Y", $day_val));
                  }
                  if(!in_array($day_val, $holiday_array[date("Y", $day_val)])){
                      $workday_counter++;
                  }
              }else{
                  $workday_counter++;
              }
          }
      }
      return $workday_counter;
  }

  /**
  * Takes a date in yyyy-mm-dd format and returns a PHP timestamp
  *
  * @param string $MySqlDate
  * @return unknown
  */
  function get_timestamp($MySqlDate)
  {

      $date_array = explode("-",$MySqlDate); // split the array

      $var_year = $date_array[0];
      $var_month = $date_array[1];
      $var_day = $date_array[2];

      $var_timestamp = mktime(0,0,0,$var_month,$var_day,$var_year);
      return($var_timestamp); // return it to the user
  }

  /**
  * Returns the date of the $ord $day of the $month.
  * For example ordinal_day(3, 'Sun', 5, 2001) returns the
  * date of the 3rd Sunday of May (ie. Mother's Day).
  *
  * @author  heymeadows@yahoo.com
  *
  * @param int $ord
  * @param string $day (must be 3 char abbrev, per date("D);)
  * @param int $month
  * @param int $year
  * @return unknown
  */
  function ordinal_day($ord, $day, $month, $year)
  {

      $firstOfMonth = get_timestamp("$year-$month-01");
      $lastOfMonth  = $firstOfMonth + date("t", $firstOfMonth) * 86400;
      $dayOccurs = 0;

      for ($i = $firstOfMonth; $i < $lastOfMonth ; $i += 86400){
          if (date("D", $i) == $day){
              $dayOccurs++;
              if ($dayOccurs == $ord){
                  $ordDay = $i;
              }
          }
      }
      return $ordDay;
  }

  function memorial_day($inc_year){
      for($date_stepper = intval(date("t", strtotime("$inc_year-05-01"))); $date_stepper >= 1; $date_stepper--){
          if(date("l", strtotime("$inc_year-05-$date_stepper"))=="Monday"){
              return strtotime("$inc_year-05-$date_stepper");
              break;
          }
      }
  }


  /**
  * Looks through a lists of defined holidays and tells you which
  * one is coming up next.
  *
  * @author heymeadows@yahoo.com
  *
  * @param int $inc_year The year we are looking for holidays in
  * @return array
  */
  function get_holidays($inc_year)
  {
      //$year = date("Y");
      $year = $inc_year;

      $holidays[] = new Holiday("New Year's Day", get_timestamp("$year-1-1"));
      $holidays[] = new Holiday("Australia Day", get_timestamp("$year-1-26"));
      $holidays[] = new Holiday("Labour Day", ordinal_day(1, 'Mon', 3, $year));
      $holidays[] = new Holiday("Anzac Day", get_timestamp("$year-4-25"));
      //$holidays[] = new Holiday("St. Patrick's Day", get_timestamp("$year-3-17"));
      // TODO: $holidays[] = new Holiday("Good Friday", easter_date($year));
      $holidays[] = new Holiday("Easter", easter_date($year));
      // TODO: $holidays[] = new Holiday("Easter Monday", easter_date($year));
      $holidays[] = new Holiday("Foundation Day", ordinal_day(1, 'Mon', 6, $year));
      $holidays[] = new Holiday("Queen's Birthday", ordinal_day(1, 'Mon', 10, $year));
      //$holidays[] = new Holiday("Memorial Day", memorial_day($year));
      //$holidays[] = new Holiday("Mother's Day", ordinal_day(2, 'Sun', 5, $year));
      //$holidays[] = new Holiday("Father's Day", ordinal_day(3, 'Sun', 6, $year));
      //$holidays[] = new Holiday("Independence Day", get_timestamp("$year-7-4"));
      //$holidays[] = new Holiday("Labor Day", ordinal_day(1, 'Mon', 9, $year));
      $holidays[] = new Holiday("Christmas", get_timestamp("$year-12-25"));
      $holidays[] = new Holiday("Boxing Day", get_timestamp("$year-12-26"));

      $numHolidays = count($holidays) - 1;
      $out_array = array();

      for ($i = 0; $i < $numHolidays; $i++){
          $out_array[] = $holidays[$i]->date;
      }
      unset($holidays);
      return $out_array;
  }

  class Holiday
  {
      //var $name;
      //var $date;
      public $name;
      public $date;

      // Contructor to define the details of each holiday as it is created.
      function holiday($name, $date){
          $this->name   = $name;   // Official name of holiday
          $this->date   = $date;   // UNIX timestamp of date
      }
  }

?>
