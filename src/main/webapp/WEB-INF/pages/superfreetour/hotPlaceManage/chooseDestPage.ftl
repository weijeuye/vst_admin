
<div class="iframe_content mt10">
    <div class="p_box box_info p_line">
        <div id="brand_tab" class="price_tab">
            <ul class="J_tab ui_tab">
                <li id="show1" ><a href="javascript:;">目的地</a></li>
                <li id="show2" ><a href="javascript:;">交通点</a></li>
            </ul>
        </div>
    </div>
    <div class="detailInfo" id="detailInfo">
    </div>
</div>
<script>
    $(function(){
        var obj = $('#show1');
        showPage(obj);
        $("#brand_tab ul li").click(function(e) {
            showPage($(this));
        });

    });

    function adaptiveWindow($obj,$obj1){
        var parentWindowObj = $obj1.parents("div.dialog-content");
        var parentWindowWidth = $obj1.parents("div.dialog-content").width();
        var parentWindowHeight= $obj1.parents("div.dialog-content").height();
        parentWindowObj.css({"overflow-x":"auto","width":parentWindowWidth});
        parentWindowObj.css({"overflow-y":"auto","height":parentWindowHeight});
        $obj.css({"width":parentWindowWidth,"height":parentWindowHeight});

    }


    function showPage(obj){
        $("#detailInfo").html("");
        var url = '';
        var id = obj.attr('id');
        if(id=='show1'){
            url = '/vst_admin/biz/dest/selectDestList.do?type=main';
        }else if(id=='show2'){
            url = '/vst_admin/superfreetour/hotPlaceManage/selectTrafficPointList.do';
        }

        for(var i=1;i<=2; i++){
            $('#show'+i).attr('class','');
        }
        obj.attr('class','active');
        var iframe = "<iframe id='main' class='iframeID' src='"+url+"' style='overflow-x:scroll; overflow-y:scroll;' width='920'  height='566'  frameborder='no' scrolling='auto'/>";
        $(".detailInfo").append(iframe);
        adaptiveWindow($("#main"),obj);

    }

</script>