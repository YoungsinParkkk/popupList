Localized file 추가

"subscribedChannel" = "가입한 스타채널";
"subscribedChannel" = "Subscribed star channel";
"subscribedChannel" = "Saluran bintang langganan";

Asset 추가
ovals.pdf


사용

let channelPopupViewController = ChannelPopupViewController.init(nibName: "ChannelPopupViewController", bundle: nil)
channelPopupViewController.modalPresentationStyle = .overFullScreen
channelPopupViewController.parentVc = self
channelPopupViewController.initModel()
channelPopupViewController.ChannelPopupDelegate = self
self.navigationController?.present(channelPopupViewController, animated: false, completion: {}


델리게이트

extension MyViewController: ChannelPopupDelegate {
    func didSelectItem(item:Channel_Popup_Model){
        print("didSelectItem : \(item.channelName) groupCD : \(item.GroupCD)")
    }
}
