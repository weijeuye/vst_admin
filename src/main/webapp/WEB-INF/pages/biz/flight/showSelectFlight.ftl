<!DOCTYPE html>
<html>
  <head>
    <#include "/base/head_meta.ftl"/>
  </head>
  <body>
  <div class="iframe_content">   
    <div class="p_box">
        <form method="post" action='/vst_admin/biz/flight/showSelectFlight.do' id="searchForm">
            <table class="s_table">
                <tbody>
                    <tr>
                        <td class="s_label">航班号：</td>
                        <td class="w18"><input type="text" id="flightNumber" name="flightNumber" value="${flightNo!''}"></td>
                        <td class="s_label">出发城市：</td>
                        <td class="w18">
                            <input type="text" id="startDistrictString" name="startDistrictString" value="${startDistrictString!''}" errorele="searchValidate" class="searchInput" readonly="readonly">
                            <input type="hidden" id="startDistrict" name="startDistrict" value="${startDistrict!''}">
                        </td>
                        <td class="s_label">到达城市：</td>
                        <td class="w18">
                            <input type="text" id="arriveDistrictString" name="arriveDistrictString" value="${arriveDistrictString!''}" errorele="searchValidate" class="searchInput" readonly="readonly">
                            <input type="hidden" id="arriveDistrict" name="arriveDistrict" value="${arriveDistrict!''}">
                        </td>
                        <td class="operate mt10"><a class="btn btn_cc1" id="search_button">查询</a></td>
                        <input type="hidden" name="page" value="${page}">
                    </tr>
                </tbody>
            </table>    
        </form>
    </div>
    
    <!-- 主要内容显示区域\\ -->
    <div class="p_box">
      <table class="p_table table_center">
        <thead>
            <tr>
                <th>选择</th>
                <th>航班号</th>
                <th>航空公司</th>
                <th>出发城市</th>
                <th>抵达城市</th>
                <th>是否有效</th>
            </tr>
        </thead>
        <tbody>
            <#list pager.items as flight> 
	            <tr>
	                <td><input type="radio" name="flightNumber" data="${flight.flightNo!''}"></td>
	                <td>${flight.flightNo!''}</td>
	                <td>${flight.airlineString!''}</td>
	                <td>${flight.startDistrictString!''}</td>
	                <td>${flight.arriveDistrictString!''}</td>
	                <td>
	                    <#if flight.cancelFlag == "Y"> 
	                        <span style="color:green" class="cancelProp">有效</span>
	                    <#elseif flight.cancelFlag == "N">
	                        <span style="color:red" class="cancelProp">无效</span>
	                    <#else>
	                        <span style="color:red" class="cancelProp"></span>
	                    </#if>
	                </td>
	            </tr>
            </#list>
        </tbody>
    </table>
    <#if pager.items?exists> 
        <div class="paging"> 
            ${pager.getPagination()}
        </div> 
    </#if>

    </div><!-- div p_box -->
    </div><!-- //主要内容显示区域 -->
    <#include "/base/foot.ftl"/>
    
    <script>
    var districtSelectDialog;
    var selectFlightDialog;
        
        //选择出发城市
        $("#startDistrictString").on('click', function(){
            districtSelectDialog = new xDialog("/vst_admin/biz/district/selectDistrictList.do",{id:"startDistrict"},{title:"选择出发城市",iframe:true,width:"1000",height:"600"});
        });
        
        //选择抵达城市
        $("#arriveDistrictString").on('click', function(){
            districtSelectDialog = new xDialog("/vst_admin/biz/district/selectDistrictList.do",{id:"arriveDistrict"},{title:"选择抵达城市",iframe:true,width:"1000",height:"600"});
        });
        
        //选择城市
        function onSelectDistrict(params){
            if(params != null){
                var districtName = params.districtName;
                var districtId = params.districtId;
                if(districtSelectDialog.data.id === "startDistrict"){
                    $("#startDistrictString").val(districtName);
                    $("#startDistrict").val(districtId);
                } else {
                    $("#arriveDistrictString").val(districtName);
                    $("#arriveDistrict").val(districtId);
                }
            }
            districtSelectDialog.close();
        }
        
        //查询
        $("#search_button").on('click',function(){
        	$("#searchForm").submit();
        });
        
        $("input[type='radio']").bind("click",function(){
            var flightNo = $(this).attr("data");
            parent.onSelectFlight(flightNo);
            selectFlightDialog.close();
        });
        
    </script>
  </body>
</html>
