
<link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css"/>
<link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/pandora-calendar.css"/>
<link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/resource-add-control.css"/>

<form action="#" enctype="multipart/form-data" method="post" target="ajaxUpload"  id="paymonryLinkImportForm" style="margin-top: 50px;margin-left: 5px;">
    <table class="p_table form-inline">
    <tbody>
          <tr> 
            <td>请选择文件：</td>  
            <td class="querytd">
               <input type="hidden" id="pid" />
			   <input type="hidden" id="fileName" />
               <input  type="file" id="uploadFile" style="width:300px;background: #4d90fe;border: 1px solid #2979fe;color: #fff;" serverType="COM_AFFIX" name="excel" onchange="javascript:getFileName(this);" /> 
               &nbsp;<span style="color: red;">支持xls、xlsx格式</span>&nbsp;
               <input type="button" class="btn btn-small " value="导入" onclick="javascript:return checkForm();" style="background: #4d90fe;border: 1px solid #2979fe;color: #fff;"/></div>
            </td>
        </tr> 
    </tbody>
</table>
</form>

<script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/pandora-calendar.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/common.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/resource-add-control.js"></script>

<script type="text/javascript">
	var basePath = "/vst_admin/pet";
</script>
<script src="/vst_admin/js/jquery.form.js"></script>

<script>
function checkForm(){
	console.log('abc');
    if($.trim($("#uploadFile").val())==''){
        alert("上传文件不可以为空");
        return false;
    }
    
    var filePath =$("#uploadFile").val();
    if (filePath.lastIndexOf(".") == -1) {
        alert("文件类型错误");
        return;
    }else {
         var suffix=filePath.substring(filePath.lastIndexOf("."));
         if(!(suffix=='.xls'||suffix=='.xlsx')){
             alert("文件名后缀不对请重新上传!");
         }
    }
    $("#result").html("");
	var action="/vst_admin/goods/recontrol/importResControlPaymentExcelData.do";
	
	var options = { 
            url:action,
            dataType:"",
            async:false,
            type : "POST", 
            success:function(data){ 
            	console.log(data);
            	if(data){
            		if(data.success){
						backstage
								.alert({
									content : "保存成功！",
									callback : function() {
				            			parent.dialogViewresPorPayMent.destroy();
									}
								});
            			/* parent.dialogViewresPorPayMent.destroy();
                    	alert("保存成功！"); */
            		}else{
                    	alert("导入失败提示信息："+data.msg);
            		}
            	}
              /*   if(data== "success") {
                    alert("操作成功!");
                    importDialog.close();
				    var url = "/vst_admin/biz/seoLink/findSeoLinkList.do";
				    $("#searchForm").attr("action",url);
		  			$("#searchForm").submit();
                } else { 
               		 var arrList = data.split(","); 
               		 if(arrList.length > 0){
               		 	$("#result").append("<tr><td> 请修正完以下问题再提交：</td></tr>");
               		 }
               		 for (i = 1; i < arrList.length; i++)
				    {
				    	$("#result").append("<tr><td>"+ arrList[i] +"</td></tr>");
				    }
                }  */
            }, 
            error:function(){ 
                alert("操作超时！"); 
            } 
        };
    $('#paymonryLinkImportForm').ajaxSubmit(options); 
    return true;
}
	
function getFileName(obj) {
	var filePath = obj.value;
	if (filePath.lastIndexOf(".") == -1) {
		alert("文件类型错误");
		return;
	}else {
		 var suffix=filePath.substring(filePath.lastIndexOf("."));
		 if(!(suffix=='.xls'||suffix=='.xlsx')){
			 alert("文件名后缀不对请重新上传!");
		 }else{
			 $("#fileName").val(suffix);
		 }
	}

}
</script>
