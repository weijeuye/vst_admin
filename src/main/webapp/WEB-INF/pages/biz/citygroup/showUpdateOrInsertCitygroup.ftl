<form method="post" id="dataForm">
<input type ="hidden" name="cityGroupId" value ="${cityGroup.cityGroupId!''}">
<div class="dialog-content clearfix" data-content="content">
            <div class="p_box box_info p_line">
                <div class="box_content ">
                    <table class="e_table form-inline ">
                        <tbody>
                             <tr>
			                     <td width="150" class="e_label td_top"><i class="cc1">*</i>城市组名称：</td>
			                     <td><label><input type="text" name="cityGroupName" id="cityGroupName" value="${cityGroup.cityGroupName!''}" required=true maxlength="35" class="w35"></label><span style="color:grey">最多可输入10个汉字</span></td>
			                 </tr>
			                <tr>
			                     <td width="150" class="e_label td_top"><i class="cc1">*</i>产品品类：</td>
			                     <td>
			                          <input type="radio" name="categoryId" value="21" class="w35" <#if cityGroup.categoryId == 21>checked=checked</#if> >&nbsp; 其他机票&nbsp;&nbsp;
			                          <input type="radio" name="categoryId" value="27" class="w35" <#if cityGroup.categoryId == 27>checked=checked</#if>>&nbsp; 其他船票&nbsp;&nbsp;
			                          <input type="radio" name="categoryId" value="23" class="w35" <#if cityGroup.categoryId == 23>checked=checked</#if>>&nbsp; 其他火车票&nbsp;&nbsp;
			                         <input type="radio" name="categoryId" value="25" class="w35" <#if cityGroup.categoryId == 25>checked=checked</#if>>&nbsp; 其他巴士&nbsp;&nbsp;
			                     </td>
			                </tr>
			                <tr>
			                     <td width="150" class="e_label td_top"><i class="cc1">*</i>所属BU：</td>
			                     <td>
			                        <select name="buCode" id="buCode">
						              <#list belongBUMap?keys as key>
	                		             <#if key == cityGroup.buCode>
	                			            <option value="${key!''}" selected="selected">${belongBUMap[key]!''}</option>
	                		            <#else>
	                		                <option value="${key!''}">${belongBUMap[key]!''}</option>
	                		            </#if> 
	                	             </#list>
						          </select>
			                     </td>
			                 </tr>
			                 <tr>
			                     <td width="120" class="e_label td_top">已选择城市：</td>
			                     <td>
			                        <div class="iframe_content">
			                           <table class="p_table table_center">
			                           	   <thead>
			                               <tr>	
				                               <th width="10%">编号</th>
				                               <th width="10%">名称</th>
				                               <th width="10%">直接上级目的地</th>
				                               <th width="10%">类型</th>				
				                               <th width="8%">操作</th>
			                              </tr>
			                              </thead>
			                              <tbody id="addedCitys">
					                       <#list bizDistrictList as bizDistrict>
					                         <tr id = "tr_in_${bizDistrict.districtId!''}">
						                        <td style="text-align:center">${bizDistrict.districtId!''} </td>
						                        <td style="text-align:center">${bizDistrict.districtName!''} </td>
						                        <td style="text-align:center">${(bizDistrict.parentDistrict.districtName)!''} </td>
						                        <td style="text-align:center">${bizDistrict.districtTypeCnName!''} </td>
						                        <td style="text-align:center"><a class="deleteCityGroupDistrictId" href="javascript:void(0);" data="${bizDistrict.districtId!''}">删除</a></td>
					                         </tr>
		                                   </#list>
                                   		   </tbody>
		                        </table>
		                     </div>
                        </tbody>
                    </table>
                </div>
            </div>
</form>

<div class="p_box box_info clearfix mb20">
     <div class="fl operate">
         <#if cityGroup.cityGroupId??>
            <a class="btn btn_cc1" href="javascript:updateCityGroup();">确认修改</a>
         <#else>
            <a class="btn btn_cc1" href="javascript:insertCityGroup();">确认创建</a>
            <a class="btn btn_cc1" href="#" onClick="javascript:go();">返回上一步</a>
         </#if>
     </div>
</div>

<script type="text/javascript">
  
  //删除城市信息
  $("a.deleteCityGroupDistrictId").bind("click",function(){
		var allCitysTr = $("#addedCitys").find('tr');

		if (typeof(allCitysTr) != 'undefined' && allCitysTr.length == 1) {
			$.alert('已选择城市不能全部删除');
			return;
		}

        var districtId = $(this).attr("data");

      	$.confirm("您确定要删除吗！", function(){
	         $.ajax({
				url : "/vst_admin/biz/citygroup/removeCityGroupByDistrictId.do",
				type : "get",
				data : {districtId : districtId},
				dataType:'JSON',
				success : function(result) {
				     if(result.code=="success"){
				        $("#tr_in_"+districtId).remove();
				      } else if (result.code=="error") {
				     	$.alert(result.message);
				     }
				}
		    });
      	});

   });

    //修改城市组信息 
      function updateCityGroup(){
         var cityGroupName = $("input[name=cityGroupName]").val();
         if(cityGroupName == ''){
            $.alert("请填写城市组信息！");
            return;
         }
         if(cityGroupName.length > 10){
            $.alert("城市组名称不能大于10个汉字！");
            return;
         }
         var categoryId = $("input[name=categoryId]:checked").val();
         if(typeof(categoryId) == 'undefined' || categoryId == ''){
           $.alert("请选择产品品类！");
           return;
         }
         var buCode = $("#buCode").val();
         if(buCode == ''){
            $.alert("请选择所属BU!");
            return;
         }

         $.ajax({
				url: '/vst_admin/biz/citygroup/updateCityGroup.do',
			    type:'POST',
			    dataType:'json',
			    data:$("#dataForm").serialize(),
			    success:function(result){
					$.alert("修改成功！");
					window.parent.location.reload("/vst_admin/biz/citygroup/findCitygroupList.do");
			    }
			});
     }
     
      //添加城市组信息 
      function insertCityGroup(){
         var cityGroupName = $("input[name=cityGroupName]").val();
         if(cityGroupName == ''){
            $.alert("请填写城市组信息！");
            return;
         }
         if(cityGroupName.length > 10){
            $.alert("城市组名称不能大于10个汉字！");
            return;
         }
         var categoryId = $("input[name=categoryId]:checked").val();
         if(typeof(categoryId) == 'undefined' || categoryId == ''){
           $.alert("请选择产品品类！");
           return;
         }
         var buCode = $("#buCode").val();
         if(buCode == ''){
            $.alert("请选择所属BU!");
            return;
         }
         $.ajax({
				url: '/vst_admin/biz/citygroup/insertCityGroup.do',
			    type:'POST',
			    dataType:'json',
			    data:$("#dataForm").serialize(),
			    success:function(result){
					$.alert("添加成功！");
					window.parent.location.reload("/vst_admin/biz/citygroup/findCitygroupList.do");
			    }
		 });
     }
     
     //返回上一步
    function go(){
       location.replace("/vst_admin/biz/citygroup/multiSelectDistrictList.do");
       insertCitygroupDialog.close();
    }
	
</script>
