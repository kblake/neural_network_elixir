defmodule NeuralNetwork.LossFunction do
  @moduledoc """
  Define loss functions.

  See more: https://medium.com/udacity-pytorch-challengers/a-brief-overview-of-loss-functions-in-pytorch-c0ddb78068f7
  """

  @doc """
  Mean Absolute Error

  Measures the mean absolute error.

  What does it mean?
  It measures the numerical distance between the estimated and actual value.
  It is the simplest form of error metric.
  The absolute value of the error is taken because if we don’t then negatives will cancel out the positives.
  This isn’t useful to us, rather it makes it more unreliable.
  The lower the value of MAE, better is the model.
  We can not expect its value to be zero, because it might not be practically useful.
  This leads to wastage of resources.
  For example, if our model’s loss is within 5% then it is alright in practice, and making it more precise may not really be useful.

  When to use it?
  - Regression problems
  - Simplistic model
  - As neural networks are usually used for complex problems, this function is rarely used.
  """
  def l1_loss(target_value, predict_value) do
    :math.abs(target_value - predict_value)
  end

  @doc """
  Mean Square Error Loss

  It measures the mean squared error (squared L2 norm).

  What does it mean?
  The squaring of the difference of prediction and actual value means that we’re amplifying large losses.
  If the classifier is off by 200, the error is 40000 and if the classifier is off by 0.1, the error is 0.01.
  This penalizes the model when it makes large mistakes and incentivizes small errors.

  When to use it?
  - Regression problems.
  - The numerical value features are not large.
  - Problem is not very high dimensional.
  """
  def mse_loss(target_value, predict_value) do
    :math.pow(target_value - predict_value, 2)
  end

  @doc """
  Smooth L1 Loss

  Also known as Huber loss, it is given by —

  What does it mean?
  It uses a squared term if the absolute error falls below 1 and an absolute term otherwise.
  It is less sensitive to outliers than the mean square error loss and in some cases prevents exploding gradients.
  In mean square error loss, we square the difference which results in a number which is much larger than the original number.
  These high values result in exploding gradients.
  This is avoided here as for numbers greater than 1, the numbers are not squared.

  When to use it?
  - Regression.
  - When the features have large values.
  - Well suited for most problems.
  """
  def smooth_l1_loss(target_value, predict_value) do
    with l1_loss_value <- l1_loss(target_value, predict_value) do
      case l1_loss_value do
        _value when _value < 1 -> squared_error(0, target_value, predict_value)
        _ -> l1_loss(target_value, predict_value) - 0.5
      end
    end
  end

  def squared_error(sum, target_value, predict_value) do
    sum + 0.5 * :math.pow(target_value - predict_value, 2)
  end

  @doc """
  Negative Log-Likelihood Loss

  The negative log-likelihood loss:

  What does it mean?
  It maximizes the overall probability of the data.
  It penalizes the model when it predicts the correct class with smaller probabilities
    and incentivizes when the prediction is made with higher probability.
  The logrithm does the penalizing part here.
  Smaller the probabilities, higher will be its logrithm.
  The negative sign is used here because the probabilities lie in the range [0, 1]
    and the logrithms of values in this range is negative.
  So it makes the loss value to be positive.

  When to use it?
  - Classification.
  - Smaller quicker training.
  - Simple tasks.
  """
  def nll_loss(target_value, predict_value) do
    :math.log(predict_value) * (-1)
  end

  @doc """
  Cross-Entropy Loss

  Measures the cross-entropy between the predicted and the target value.

  where target_value is the probability of true label and predict_value is the probability of predicted label.
  What does it mean?
  Cross-entropy as a loss function is used to learn the probability distribution of the data.
  While other loss functions like squared loss penalize wrong predictions,
    cross entropy gives a greater penalty when incorrect predictions are predicted with high confidence.
  What differentiates it with negative log loss is that cross entropy also penalizes wrong
    but confident predictions and correct but less confident predictions,
    while negative log loss does not penalize according to the confidence of predictions.

  When to use it?
  - Classification tasks
  - For making confident model i.e. model will not only predict accurately, but it will also do so with higher probability.
  - For higher precision/recall values.
  """
  def cross_entropy_loss(target_value, predict_value) do
    # to-do
  end

  @doc """
  Kullback-Leibler divergence

  KL divergence gives a measure of how two probability distributions are different from each other.

  where x is the probability of true label and y is the probability of predicted label.

  What does it mean?
  It is quite similar to cross entropy loss.
  The distinction is the difference between predicted and actual probability.
  This adds data about information loss in the model training.
  The farther away the predicted probability distribution is from the true probability distribution, greater is the loss.
  It does not penalize the model based on the confidence of prediction,
    as in cross entropy loss, but how different is the prediction from ground truth.
  It usually outperforms mean square error, especially when data is not normally distributed.
  The reason why cross entropy is more widely used is that it can be broken down as a function of cross entropy.
  Minimizing the cross-entropy is the same as minimizing KL divergence.

  KL = — xlog(y/x) = xlog(x) — xlog(y) = Entropy — Cross-entropy

  When to use it?
  - Classification
  - Same can be achieved with cross entropy with lesser computation, so avoid it.
  """
  def kl_div_loss(target_value, predict_value) do
    # to-do
  end
end
