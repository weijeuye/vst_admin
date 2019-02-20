<#assign mis=JspTaglibs["/WEB-INF/pages//tld/lvmama-tags.tld"]>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>编辑基本信息</title>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css" />
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/pandora-calendar.css" />
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/subcompany/base.css" />
</head>

<body class="edit-basic-info my-body">
    <div class="main">
        <p class="main-title">基本信息</p>
        <form action="/vst_admin/o2o/subCompany.do" method="post" id="dataForm">
            <dl class="clearfix">
                <dt>
                    <label for="">
                        所在地：
                    </label>
                </dt>
                <dd>
                    <div class="form-group col mr10">
                        <input name="locations" maxlength="30" type="text" class="form-control w85 mr5" />
                        <input name="locations" maxlength="30" type="text" class="form-control w85 mr5" />
                        <input name="locations" maxlength="30" type="text" class="form-control w85 mr5" />
                        <input name="locations" maxlength="30" type="text" class="form-control w85 mr5" />
                    </div>
                </dd>
                <dt>
                    <label for="">
                        子公司名称：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="name" type="text" data-validate="{required:true}" class="form-control w395" maxlength="90" placeholder="最多90个汉字" />
                    </div>
                </dd>
                <dt>
                    <label for="">
                        旅行社许可证号：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="permitNo" maxlength="50" type="text" class="form-control w200" />
                    </div>
                </dd>
                <dt>
                    <label>
                        资质：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <select class="form-control w210" name="aptitude">
                            <#list aptitudeTypes as item> 
		                    	<option value="${item.code}">${item.cnName}</option>
		                	</#list>
                        </select>
                    </div>
                </dd>
                <dt>
                    <label for="">
                        法定代表人：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="legalRep" maxlength="25" type="text" class="form-control w200"/>
                    </div>
                </dd>
                <dt>
                    <label for="">
                        注册地址：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="registeredAddress" maxlength="120" type="text" class="form-control w395"/>
                    </div>
                </dd>
                <dt>
                    <label for="">
                        经营地址：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="businessAddress" maxlength="120" type="text" class="form-control w395" />
                    </div>
                </dd>
                <dt>
                    <label for="">
                        邮编：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="zip" type="text" data-validate="{regular:仅支持输入字母数字}" data-validate-regular="^[A-Za-z0-9]{1,6}$" maxlength="6" class="form-control w200" />
                    </div>
                </dd>
                <dt>
                    <label for="">
                        公司网址：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="site" maxlength="40" type="text" class="form-control w200" />
                    </div>
                </dd>
                <dt>
                    <label for="">
                        管辖区域：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="manageArea" maxlength="120" type="text" class="form-control w395" />
                        <span class="input-tip">请用“、”隔开</span>
                    </div>
                </dd>
                <dt>
                    <label for="">
                        子公司状态：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                    	<select class="form-control w200" name="coStatus">
		                    	<option value='Y'>有效</option>
		                    	<option value='N'>无效</option>
                        </select>
                    </div>
                </dd>
            </dl>
            <div class="btn-group text-center">
            	<@mis.checkPerm permCode="5120">
                	<a class="btn btn-primary JS_btn_save">保存</a>
            	</@mis.checkPerm >
            </div>
        </form>
    </div>
    <script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
    <script src="http://pic.lvmama.com/js/backstage/v1/common.js"></script>
    <script src="http://pic.lvmama.com/js/backstage/v1/vst/subcompany/base.js"></script>
    <script src="http://pic.lvmama.com/js/backstage/v1/common/validate.js"></script>
    <script>
   $(function() {

        var $document = $(document);

        // 表单验证
        var $form = $("#dataForm");
        var validateAdd = backstage.validate({
            $area: $form,
            REQUIRED: "不能为空",
            showError: true
        });
        validateAdd.watch();

        $document.on("click", ".JS_btn_save", function() {
            validateAdd.refresh();
            validateAdd.watch();
            validateAdd.test();
            if (validateAdd.getIsValidate()) {
            	$(".JS_btn_save").hide();
            	var loading = backstage.loading({
				    title: "系统提醒消息",
				    content: '<p><i class="icon-loading"></i>' + '正在保存中' + '</p>'
				});
                backstage.confirm({
                	content: "确定要保存么？",
                	determineCallback: function(){
						$.ajax({
							url : "/vst_admin/o2o/subCompany.do",
							type : "post",
							dataType : 'json',
							data : $("#dataForm").serialize(),
							success : function(result) {
								loading.destroy();
								if(result.code == "success"){
									//为父窗口设置productId
									backstage.alert({
						   		  		content: result.message,
						   		  		callback: function () {
											$("#subCompanyId",window.parent.document).val(result.attributes.subCompanyId);
											$("#viewType",window.parent.document).val("WRITABLE");
						   		  			$("#subco_base", window.parent.document).parent("li").click();
						   		  		}
						   		  	});
								}else {
									backstage.alert({
						   		  		content: result.message,
						   		  		callback: function () {
						   		  			$(".JS_btn_save").show();
						   		  		}
						   		  	});
								}
							},
							error : function(){
								loading.destroy();
								$(".JS_btn_save").show();
							}
						  })
					},
					cancelCallback: function(){
						loading.destroy();
						$(".JS_btn_save").show();
					}
				});
            }
        });
    });
    </script>
</body>

</html>
