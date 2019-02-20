/**
 * Created by niuchen on 2015/12/14.
 */
$(function(){

    //弹出层
    var $template = $(".template");
    var $document = $(document);

    //操作日志
//    var $btnAttachAdd = $(".JS_show_dialog_operationLog");
//
//    $btnAttachAdd.on("click", attachAddHandler);
//    function attachAddHandler() {
//
//        var $this = $(this);
//        var $addAttach = $template.find(".dialog-operationLog").clone();
//
//        window.addAttachDialog = backstage.dialog({
//            title: "日志详情页",
//            width: 1000,
//            height:600,
//            $content: $addAttach
//        });
//
//        var url = "operationLog.html";
//        var $iframe = $addAttach.find(".iframe-operation-log");
//        $iframe.attr("src", url);
//    }

//    //新增
//    $(".JS_add_baseInform").click(function(){
//        var $this = $(this);
//        console.log($this.html());
//        var $addAttach = $template.find(".dialog-addBaseInformation").clone();
//
//        window.addAttachDialog = backstage.dialog({
//            title: "新增活动",
//            width: 1100,
//            height:700,
//            $content: $addAttach
//        });
//
//        var url = "/vst_admin/prod/promotion/desc/toAdd.do";
//        var $iframe = $addAttach.find(".iframe-addBaseInformation");
//        $iframe.attr("src", url);
//    });

    
    ////修改
    //$(".JS_edit_baseInform").click(function(){
    //    var $this = $(this);
    //    console.log($this.html());
    //    var $addAttach = $template.find(".dialog-editBaseInformation").clone();
    //
    //    window.addAttachDialog = backstage.dialog({
    //        title: "修改活动",
    //        width: 800,
    //        height:700,
    //        $content: $addAttach
    //    });
    //
    //    var url = "editBaseInformation.html";
    //    var $iframe = $addAttach.find(".iframe-editBaseInformation");
    //    $iframe.attr("src", url);
    //});
    //$('.JS_btn_bound').click(function(){
    //    window.parent.addAttachDialog.destroy();
    //    //window.parent.parent.location.href='boundProduct.html';
    //});

})



$(function(){


})


//绑定产品页面的tab切换
tab();
function tab(){
    $('.tab-box').each(function(){
        var $this=$(this),
            $li=$this.find('.nav-tabs li'),
            $tabContent=$this.find('.tab-content');
            $li.eq(0).addClass('active');
            $tabContent.eq(0).show();
            $li.click(function(){
                var index=$(this).index();
                $li.removeClass('active').eq(index).addClass('active');
                $tabContent.hide().eq(index).show();
            });
    });
}

