<div style="height:140px;position:relative;">
  <form id="dataForm">
    <input type="hidden" name="productId" value="${productId}" />
    <input type="hidden" id="categoryId" value="${categoryId}" />
    <div style="margin-left:50px;">
    <p>
      <span>
        • 下单时游玩人信息可不填写
      </span>
    </p>
    <p>
      <span>
        • 订单生成后支持游玩人信息补充/编辑
      </span>
    </p>
	    <div style="padding-left:40px;">
		    <label>
		      <input type="radio" style="vertical-align:middle;" name="travellerDelayFlag" value="Y" <#if travellerDelayFlag=="Y">checked="checked"</#if>/>可以
		    </label>
		    &nbsp;&nbsp;&nbsp;
		    <label>
		      <input type="radio" style="vertical-align:middle;" name="travellerDelayFlag" value="N" <#if travellerDelayFlag=="N">checked="checked"</#if>/>不可以
		    </label>
	    </div>
    </div>
  </form>
<div class="p_box box_info clearfix mb20" style="position: absolute;top:100px;margin:5px;margin-left:80px;">
  <div class="fl operate">
    <a class="btn btn_cc1" id="save">保存</a>
  </div>
   <div class="fl operate">
    <a class="btn btn_cc1" id="cancel">取消</a>
  </div>
</div>
</div>
<script>

$(function() {

    var categoryId = $("#categoryId").val();
	/*
	 设置产品后置状态
	*/
    $("#save").bind("click",function() {

        if ($("input[name='travellerDelayFlag']:checked").size() == 0) {
            $.alert("请选择其中一项");
            return;
        }

        var url="/vst_admin/prod/product/saveProdTravellerConfig.do";
        // 邮轮分支走邮轮url, 邮轮(2),邮轮组合(8),邮轮附加(10),岸上观光(9)
        if(categoryId=="2"||categoryId=="8"||categoryId=="9"||categoryId=="10"){
            url = "/ship_back/prod/product/saveProdTravellerConfig.do";
        }

        $.ajax({
            type: "POST",
            url: url,
            data: $("#dataForm").serialize(),
            success: function(data) {
                if (data.code == "success") {
                    $.alert("设置成功");
                     travellerDelayDialog.close();
                } else {
                    $.alert("设置失败");
                }
            },
            error: function(){
                $.alert("设置失败");
            }
        });
    });
    
    $("#cancel").bind("click",function(){
    	$(".dialog-close").trigger("click");
    });
    
});
</script>