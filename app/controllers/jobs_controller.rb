class JobsController < ApplicationController
  def trigger
    # MyJob.perform_later(params[:job_params])
    job = ImportPipedriveFieldsJob.perform_later
    render json: { status: 'Job triggered: ' + job.to_s }
  end
end
