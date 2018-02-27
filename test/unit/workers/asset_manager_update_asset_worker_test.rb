require 'test_helper'

class AssetManagerUpdateAssetWorkerTest < ActiveSupport::TestCase
  setup do
    @asset_id = 'asset-id'
    @asset_url = "http://asset-manager/assets/#{@asset_id}"
    @legacy_url_path = 'legacy-url-path'
    @worker = AssetManagerUpdateAssetWorker.new
    @redirect_url = 'https://www.test.gov.uk/example'
  end

  test 'does not update asset if no attributes are supplied' do
    Services.asset_manager.stubs(:whitehall_asset).with(@legacy_url_path)
      .returns('id' => @asset_url)
    Services.asset_manager.expects(:update_asset).never

    @worker.perform(@legacy_url_path)
  end

  test 'marks draft asset as published' do
    @worker.stubs(:find_asset_by).with(@legacy_url_path)
      .returns('id' => @asset_id, 'draft' => true)
    Services.asset_manager.expects(:update_asset).with(@asset_id, 'draft' => false)

    @worker.perform(@legacy_url_path, 'draft' => false)
  end

  test 'does not mark asset as published if already published' do
    @worker.stubs(:find_asset_by).with(@legacy_url_path)
      .returns('id' => @asset_id, 'draft' => false)
    Services.asset_manager.expects(:update_asset).never

    @worker.perform(@legacy_url_path, 'draft' => false)
  end

  test 'mark published asset as draft' do
    @worker.stubs(:find_asset_by).with(@legacy_url_path)
      .returns('id' => @asset_id, 'draft' => false)
    Services.asset_manager.expects(:update_asset).with(@asset_id, 'draft' => true)

    @worker.perform(@legacy_url_path, 'draft' => true)
  end

  test 'does not mark asset as draft if already draft' do
    @worker.stubs(:find_asset_by).with(@legacy_url_path)
      .returns('id' => @asset_id, 'draft' => true)
    Services.asset_manager.expects(:update_asset).never

    @worker.perform(@legacy_url_path, 'draft' => true)
  end

  test 'sets redirect_url on asset if not already set' do
    @worker.stubs(:find_asset_by).with(@legacy_url_path)
      .returns('id' => @asset_id)
    Services.asset_manager.expects(:update_asset)
      .with(@asset_id, 'redirect_url' => @redirect_url)

    @worker.perform(@legacy_url_path, 'redirect_url' => @redirect_url)
  end

  test 'sets redirect_url on asset if already set to different value' do
    @worker.stubs(:find_asset_by).with(@legacy_url_path)
      .returns('id' => @asset_id, 'redirect_url' => "#{@redirect_url}-another")
    Services.asset_manager.expects(:update_asset)
      .with(@asset_id, 'redirect_url' => @redirect_url)

    @worker.perform(@legacy_url_path, 'redirect_url' => @redirect_url)
  end

  test 'does not set redirect_url on asset if already set' do
    @worker.stubs(:find_asset_by).with(@legacy_url_path)
      .returns('id' => @asset_id, 'redirect_url' => @redirect_url)
    Services.asset_manager.expects(:update_asset).never

    @worker.perform(@legacy_url_path, 'redirect_url' => @redirect_url)
  end

  test 'marks asset as access-limited' do
    @worker.stubs(:find_asset_by).with(@legacy_url_path)
      .returns('id' => @asset_id)
    Services.asset_manager.expects(:update_asset).with(@asset_id, 'access_limited' => ['uid-1'])

    @worker.perform(@legacy_url_path, 'access_limited' => ['uid-1'])
  end

  test 'does not mark asset as access-limited if already set' do
    @worker.stubs(:find_asset_by).with(@legacy_url_path)
      .returns('id' => @asset_id, 'access_limited' => ['uid-1'])
    Services.asset_manager.expects(:update_asset).never

    @worker.perform(@legacy_url_path, 'access_limited' => ['uid-1'])
  end
end
