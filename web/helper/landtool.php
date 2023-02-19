<?php
error_reporting(E_ALL  & ~E_NOTICE); 

# Copyright (c)Melanie Thielker and Teravus Ovares (http://opensimulator.org/)
#
#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions are met:
#      * Redistributions of source code must retain the above copyright
#        notice, this list of conditions and the following disclaimer.
#      * Redistributions in binary form must reproduce the above copyright
#        notice, this list of conditions and the following disclaimer in the
#        documentation and/or other materials provided with the distribution.
#      * Neither the name of the OpenSim Project nor the
#        names of its contributors may be used to endorse or promote products
#        derived from this software without specific prior written permission.
#
#  THIS SOFTWARE IS PROVIDED BY THE DEVELOPERS ``AS IS'' AND ANY
#  EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
#  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#  DISCLAIMED. IN NO EVENT SHALL THE CONTRIBUTORS BE LIABLE FOR ANY
#  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
#  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
#  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
#  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# updated for Robust installations: BlueWall 2011
# further minor changes by justincc (http://justincc.org)

  function xlog($text) {
    global $IP;
    $datum   = date("Y-m-d H:i:s");
    $fh = fopen('landtool.log', 'a'); // bitte anpassen
    fwrite($fh, $datum."# ".$IP."|".$text."\n");
    fclose($fh);
}
    xlog(".. ");    
    $request_xml = file_get_contents("php://input");
    //xlog("Call... request_xml -  ".$request_xml);


  # Please insert youre database Settings
  $dbhost = "localhost"; // do not enter this
  $dbname = "grid_database"; // youre database name
  $dbuser = "user_name"; // youre mysql name
  $dbpass = "user_paswd"; // youre mysql password
  # Tables
  $presence = "Presence";
  
  # Splt Post raw Content as an effect because somethin does not more run under php 7.x
  $search  = array('<', '>', 'methodCall', '?xml version="1.0"?', '/', 'xxx', 'methodName', 'membername' , 'params' , 'param' , 'value' , 'struct', 'member', 'name', 'string', 'int'); 
  $xml = str_replace($search, ">" ,$request_xml);
  $search  = array( '>>'); 
  $xml = str_replace($search, ">" ,$xml);
  $xml = str_replace($search, ">" ,$xml);
  $xml = str_replace($search, ">" ,$xml);
  $xml = str_replace($search, ">" ,$xml);
  $xml = str_replace($search, ">" ,$xml);
  $xml = str_replace($search, ">" ,$xml);
  $xml_split = preg_split("[>]", $xml); 
      //xlog("Call... xml 0 ".$xml);
    //  0 n/a
    //  1 preflightBuyLandPrep
    $method_name = $xml_split[1];
    //xlog("Call... method_name : ".$method_name );
    //  2 agentId
    //  3 d8384ae7-ae6a-4a36-a254-9d62f59f695f
    $agentId = $xml_split[3];
    //xlog("Call... agentId : ".$agentId );
    //  4 secureSessionId
    //  5 0f5eddde-13ef-4aaa-85f6-03134566ef3f
    $secureSessionId = $xml_split[5];
    //xlog("Call... secureSessionId : ".$secureSessionId );
    //  6 language
    //  7 de
    //  8 billableArea 
    //  9 0
    $billableArea = $xml_split[9];
    //xlog("Call... billableArea : ".$billableArea );
    //  10 currencyBuy 
    //  11 0  
    $amount = $xml_split[11];
    //xlog("Call... amount : ".$amount );
    //  12 n/a
    //xlog("Call... xml_split 0 ".$xml_split[0]);
    //xlog("Call... xml_split 1 ".$xml_split[1]);
    //xlog("Call... xml_split 2 ".$xml_split[2]);
    //xlog("Call... xml_split 3 ".$xml_split[3]);
    //xlog("Call... xml_split 4 ".$xml_split[4]);
    //xlog("Call... xml_split 5 ".$xml_split[5]);
    //xlog("Call... xml_split 6 ".$xml_split[6]);
    //xlog("Call... xml_split 7 ".$xml_split[7]);
    //xlog("Call... xml_split 8 ".$xml_split[8]);
    //xlog("Call... xml_split 9 ".$xml_split[9]);
    //xlog("Call... xml_split 10 ".$xml_split[10]);
    //xlog("Call... xml_split 11 ".$xml_split[11]);
    //xlog("Call... xml_split 12 ".$xml_split[12]);

  
  # XMLRPC
  $xmlrpc_server = xmlrpc_server_create();
  xmlrpc_server_register_method($xmlrpc_server, "preflightBuyLandPrep", "buy_land_prep");
////////////////////////////////////////////

function validate_user($agent_id, $s_session_id)
  {
    global $dbhost, $dbuser, $dbpass, $dbname;
    //$agentid = mysql_escape_string($agentId);
    //$sessionid = mysql_escape_string($secureSessionId);
       
    # New MySqli Connect
    $mysqli = new mysqli($dbhost, $dbuser, $dbpass, $dbname);
    if ($mysqli->connect_found) {
    die("Connection failed: " . $mysqli->connect_found);
    }
    # New MySqli Connect end
    
    $query = "select UserID from Presence where UserID='".$agent_id."' and SecureSessionID = '".$s_session_id."'";
//    $result = mysql_query($query)
//      or die('ERROR: '.mysql_error());
//    $row = mysql_fetch_assoc($result);
//    return $row['UserID'];
//  }
    # New MySqli Event
    $result = $mysqli->query($query);
    if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
    #
    $UserID = $row['UserID'];
        //xlog("validate_user Succsess! [".$query."]");
    }} else {
      
    // xlog("validate_user Fail! [".$query."]");
     return ; 
    }
    # New MySqli Event end
    return $UserID;
}
//xlog("Call... Function Test validate_user  a ".validate_user($agentId, $secureSessionId)) ;


    //xlog("Call... method_name :> ".$method_name );
    //xlog("Call... agentId :> ".$agentId );
    //xlog("Call... secureSessionId :> ".$secureSessionId );

function buy_land_prep($method_name)
  {
    global $dbhost, $dbuser, $dbpass, $dbname , $agentId, $secureSessionId, $amount, $billableArea;
    $confirmvalue = "";
    
    //xlog("Call.buy_land_prep. method_name :>> ".$method_name );
    //xlog("Call.buy_land_prep. agentId :>> ".$agentId );
    //xlog("Call.buy_land_prep. secureSessionId :>> ".$secureSessionId );
    //xlog("Call.buy_land_prep. amount :>> ".$amount );
    //xlog("Call.buy_land_prep. billableArea :>> ".$billableArea );    

    $ID = validate_user($agentId, $secureSessionId);
    //xlog("Call.buy_land_prep. ID :>>> ".$ID );

    
if ( $amount != 0) {
      header("Content-type: text/xml");
      $response_xml = xmlrpc_encode(array(
        'success' => False,
        'errorMessage' => "\n\nLand/Parcels can only sell for 0!\nCall the Landowner ....",
        'errorURI' => "http://www.google.de"));
      print $response_xml;
      return;
  } 

  if($ID)
    {
      $membership_levels = array(
        'levels' => array(
        'id' => "00000000-0000-0000-0000-000000000000",
        'description' => "some level"));
      $landUse = array(
        'upgrade' => False,
        'action'  => "http://www.google.de");
      $currency = array(
        'estimatedCost' =>  "200.00");     // convert_to_real($amount));
      $membership = array(
        'upgrade' => False,
        'action'  => "http://www.google.de",
        'levels'  => $membership_levels);
      $response_xml = xmlrpc_encode(array(
         'success'    => True,
         'currency'   => $currency,
         'membership' => $membership,
         'landUse'    => $landUse,
         'currency'   => $currency,
         'confirm'    => $confirmvalue));
       header("Content-type: text/xml");
       print $response_xml;
    }
    else
    {    
      header("Content-type: text/xml");
      $response_xml = xmlrpc_encode(array(
        'success' => False,
        'errorMessage' => "\n\nUnable to Authenticate\n\nClick URL for more info.",
        'errorURI' => "http://www.google.de"));
      print $response_xml;
    }
    
    return "";
  }

////////////////////////////////////////////

  #$request_xml = $HTTP_RAW_POST_DATA;
  $request_xml = file_get_contents("php://input");
  xmlrpc_server_call_method($xmlrpc_server, $request_xml, '');
  xmlrpc_server_destroy($xmlrpc_server);
?>