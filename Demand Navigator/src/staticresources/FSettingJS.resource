function setFocusOnLoad() {}
		
        function confirmStatus(isEditable,monthId,yearId,oldstatus,obj){
            
            
            var status = obj.value;
            if(status == '') obj.value = oldstatus;
            if(status == '')
            return false;
            
            var Msg = '';
            
            var $PeriodStatusIds = $("[id*='PeriodStatusId']");
            var OpenCount = 0;
            for (i=0; i < $PeriodStatusIds.length; i++){
                
                if($PeriodStatusIds[i].value == 'Open'){
                    OpenCount++;
                }
            }
             
            var EditableMonths = '{!EditableMonths}';
            var isCurrentMonth = false;
            if(EditableMonths.indexOf(yearId+'-'+monthId) > -1){
                isCurrentMonth = true;
            }
            
            
            if(oldstatus == 'Not Open'){
                if(status == 'Open'){
                     if(OpenCount > 1){
                         Msg ='Do you want to proceed?';
                         Msg = Msg+'\nOne or more periods is currently in Open status. This will allow you to enter data in multiple periods';
                                     
                     }
                     if(isCurrentMonth == false){
                         Msg ='Do you want to proceed?:';
                         Msg = Msg+'\nYou are trying to Open a Period that does not reflect the current or next Period. This will allow data entry or updates that may impact all reports and calculations.';
                     }
                     if(OpenCount > 1 && isCurrentMonth == false){
                         Msg ='Do you want to proceed?';
                         Msg = Msg+'\n(1) One or more periods is currently in Open status. This will allow you to enter data in multiple periods.';
                         Msg = Msg+'\n(2) You are trying to Open a Period that does not reflect the current or next Period. This will allow data entry or updates that may impact all reports and calculations.';
                     }
                }
                else if(status == 'Closed'){
                    Msg ='Error';
                    Msg = Msg+'\nThis period has not been previously Opened. Cannot change status to Closed.';
                    obj.value = 'Not Open';
                }
            }
            else if(oldstatus == 'Open'){
                if(status == 'Not Open'){
                   Msg ='Error';
                   Msg = Msg+'\nThis period was previously Open and can only be set to the Closed status.';
                   obj.value = 'Open';
                }
                else if(status == 'Closed'){
                    Msg ='Do you want to proceed?';
                    Msg = Msg+'\nYou are about to close an Open period. Users will not be able to enter data in this period once it is closed.';
                }
            }
            else if(oldstatus == 'Closed'){
                if(status == 'Open'){
                    Msg ='Do you want to proceed?';
                    Msg ='\nYou are about to Open that was previously closed. This will allow you to enter or update existing data that may impact all a Period.';
                }
                else if(status == 'Not Open'){
                    Msg ='Error';
                    Msg = Msg+'\nThis period was previously closed and can only be set to the Open status.';
                    obj.value = 'Closed';
                }
            }
            
            
            if(Msg == ''){
                //onstatuschange(monthId,yearId);
                return false;
            }
            
            var isDelete = confirm(Msg);
            if (isDelete) {
                //onstatuschange(monthId,yearId);
                return true;
            }
            return false;
        }    